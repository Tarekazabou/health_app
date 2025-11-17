import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'mock_data_service.dart';
import '../core/constants/constants.dart';
import 'dart:convert';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  final MockDataService _mockDataService = MockDataService();
  
  // Bluetooth state
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _dataCharacteristic;
  StreamSubscription<List<int>>? _characteristicSubscription;
  
  // Data stream
  final StreamController<Map<String, dynamic>> _dataStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  
  // Mode flag
  bool _useMockData = true; // Default to mock mode for testing
  bool _isScanning = false;
  bool _isConnected = false;

  // Getters
  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  bool get useMockData => _useMockData;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  
  // Set mock mode
  void setMockMode(bool useMock) {
    _useMockData = useMock;
    if (useMock && !_isConnected) {
      startMockDataStream();
    }
  }

  // Initialize Bluetooth
  Future<bool> initialize() async {
    try {
      // Check if Bluetooth is supported
      if (await FlutterBluePlus.isSupported == false) {
        print('Bluetooth not supported on this device');
        return false;
      }

      // Check Bluetooth state
      final state = await FlutterBluePlus.adapterState.first;
      if (state != BluetoothAdapterState.on) {
        print('Bluetooth is not turned on');
        return false;
      }

      return true;
    } catch (e) {
      print('Bluetooth initialization error: $e');
      return false;
    }
  }

  // Start mock data stream
  void startMockDataStream() {
    if (_useMockData) {
      _mockDataService.startGeneratingData().listen((data) {
        _dataStreamController.add(data);
      });
      _isConnected = true;
    }
  }

  // Scan for ESP32 devices
  Future<List<BluetoothDevice>> scanForDevices({Duration timeout = const Duration(seconds: 10)}) async {
    if (_useMockData) {
      // Return mock device
      return [];
    }

    _isScanning = true;
    final devices = <BluetoothDevice>[];

    try {
      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (var result in results) {
          if (!devices.contains(result.device)) {
            // Filter for ESP32 devices (check name or service UUID)
            if (result.device.platformName.contains('ESP32') ||
                result.device.platformName.contains('HealthTrack')) {
              devices.add(result.device);
            }
          }
        }
      });

      // Wait for timeout
      await Future.delayed(timeout);
      
      // Stop scanning
      await FlutterBluePlus.stopScan();
      await subscription.cancel();
      
      _isScanning = false;
      return devices;
    } catch (e) {
      print('Scan error: $e');
      _isScanning = false;
      return devices;
    }
  }

  // Connect to device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    if (_useMockData) {
      startMockDataStream();
      return true;
    }

    try {
      // Connect to device
      await device.connect(timeout: AppConstants.bleConnectionTimeout);
      _connectedDevice = device;

      // Discover services
      final services = await device.discoverServices();
      
      // Find the data characteristic
      for (var service in services) {
        if (service.uuid.toString() == AppConstants.bleServiceUuid) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == AppConstants.bleCharacteristicUuid) {
              _dataCharacteristic = characteristic;
              
              // Subscribe to notifications
              await characteristic.setNotifyValue(true);
              
              _characteristicSubscription = characteristic.lastValueStream.listen((value) {
                _handleIncomingData(value);
              });
              
              _isConnected = true;
              return true;
            }
          }
        }
      }

      return false;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  // Handle incoming BLE data
  void _handleIncomingData(List<int> value) {
    try {
      // Convert bytes to string
      final jsonString = utf8.decode(value);
      
      // Parse JSON
      final data = json.decode(jsonString) as Map<String, dynamic>;
      
      // Add to stream
      _dataStreamController.add(data);
    } catch (e) {
      print('Data parsing error: $e');
    }
  }

  // Disconnect from device
  Future<void> disconnect() async {
    try {
      await _characteristicSubscription?.cancel();
      await _connectedDevice?.disconnect();
      _mockDataService.stop();
      
      _connectedDevice = null;
      _dataCharacteristic = null;
      _characteristicSubscription = null;
      _isConnected = false;
    } catch (e) {
      print('Disconnect error: $e');
    }
  }

  // Get battery level (if available)
  Future<int?> getBatteryLevel() async {
    if (_useMockData) {
      return 80; // Mock battery level
    }

    // TODO: Implement battery level characteristic read
    return null;
  }

  // Dispose
  void dispose() {
    _dataStreamController.close();
    _mockDataService.dispose();
    disconnect();
  }
}
