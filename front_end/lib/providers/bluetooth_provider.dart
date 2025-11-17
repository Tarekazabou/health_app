import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/bluetooth_service.dart' as app_bluetooth;

class BluetoothProvider extends ChangeNotifier {
  final app_bluetooth.BluetoothService _bluetoothService = app_bluetooth.BluetoothService();
  
  bool _isScanning = false;
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _isMockMode = true; // Start in mock mode by default
  
  List<BluetoothDevice> _availableDevices = [];
  BluetoothDevice? _connectedDevice;
  String? _deviceName;
  String? _deviceId;
  int _batteryLevel = 0;
  
  String? _error;
  
  // Getters
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  bool get isMockMode => _isMockMode;
  List<BluetoothDevice> get availableDevices => _availableDevices;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  String? get deviceName => _deviceName;
  String? get deviceId => _deviceId;
  int get batteryLevel => _batteryLevel;
  String? get error => _error;
  
  String get connectionStatus {
    if (_isConnecting) return 'Connecting...';
    if (_isConnected) return 'Connected';
    if (_isMockMode) return 'Mock Mode';
    return 'Disconnected';
  }
  
  BluetoothProvider() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    // Auto-start in mock mode with live data simulation
    _isMockMode = true;
    _isConnected = true;
    _deviceName = 'ESP32 HealthTrack';
    _deviceId = 'MOCK-ESP32-001';
    _batteryLevel = 85;
    
    // Start generating mock data automatically
    _bluetoothService.setMockMode(true);
    _bluetoothService.startMockDataStream();
    
    // Simulate battery drain
    Timer.periodic(const Duration(minutes: 5), (timer) {
      if (_isConnected && _batteryLevel > 0) {
        _batteryLevel = (_batteryLevel - 1).clamp(0, 100);
        notifyListeners();
      }
    });
    
    notifyListeners();
  }
  
  /// Start scanning for Bluetooth devices
  Future<void> startScan() async {
    try {
      _isScanning = true;
      _error = null;
      _availableDevices.clear();
      notifyListeners();
      
      final devices = await _bluetoothService.scanForDevices(
        timeout: const Duration(seconds: 10),
      );
      
      _availableDevices = devices;
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _error = 'Scan failed: $e';
      _isScanning = false;
      notifyListeners();
    }
  }
  
  /// Stop scanning
  Future<void> stopScan() async {
    try {
      // BluetoothService doesn't have stopScan method
      // Just update state
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to stop scan: $e';
      notifyListeners();
    }
  }
  
  /// Connect to a Bluetooth device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      _isConnecting = true;
      _error = null;
      notifyListeners();
      
      final success = await _bluetoothService.connectToDevice(device);
      
      if (success) {
        _isConnected = true;
        _connectedDevice = device;
        _deviceName = device.platformName;
        _deviceId = device.remoteId.toString();
        _isMockMode = false;
        _isConnecting = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to connect to device';
        _isConnecting = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Connection failed: $e';
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Disconnect from current device
  Future<void> disconnect() async {
    try {
      await _bluetoothService.disconnect();
      _isConnected = false;
      _connectedDevice = null;
      _deviceName = null;
      _deviceId = null;
      _batteryLevel = 0;
      notifyListeners();
    } catch (e) {
      _error = 'Disconnection failed: $e';
      notifyListeners();
    }
  }
  
  /// Toggle mock mode (for testing without hardware)
  void toggleMockMode() {
    _isMockMode = !_isMockMode;
    _bluetoothService.setMockMode(_isMockMode);
    
    if (_isMockMode) {
      // In mock mode, simulate connection
      _isConnected = true;
      _deviceName = 'Mock ESP32 Device';
      _deviceId = 'MOCK-DEVICE-001';
      _batteryLevel = 85;
    } else {
      // When disabling mock mode, disconnect
      _isConnected = false;
      _deviceName = null;
      _deviceId = null;
      _batteryLevel = 0;
    }
    
    notifyListeners();
  }
  
  /// Update battery level
  void updateBatteryLevel(int level) {
    _batteryLevel = level.clamp(0, 100);
    notifyListeners();
  }
  
  /// Check if Bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    try {
      // BluetoothService doesn't have this method
      // Return true for mock mode
      return _isMockMode;
    } catch (e) {
      _error = 'Failed to check Bluetooth status: $e';
      notifyListeners();
      return false;
    }
  }
  
  /// Request Bluetooth permissions
  Future<bool> requestPermissions() async {
    try {
      // BluetoothService doesn't have this method
      // Return true for mock mode
      return true;
    } catch (e) {
      _error = 'Permission request failed: $e';
      notifyListeners();
      return false;
    }
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
