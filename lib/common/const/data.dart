
const emulatorIp = '10.0.2.2:8000';
const simulatorIp = '127.0.0.1:8000';
//final simulatorIp = '192.168.2.23:8000';
// '172.30.1.65:8000';
const ip = '192.168.0.32:8000'; //Platform.isIOS ? simulatorIp : emulatorIp;
//final ip = Platform.isIOS ? simulatorIp : emulatorIp;

class ConstValues {
  static const bottomNavigationBarHeight = 91.0;
  static const dialogWidthPercentage = 0.782;
  static const drawerWidthPercentage = 0.8;
}

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const List<int> intMinutes = [0, 1, 2, 3, 4, 5, 6, 7, 8];
const List<int> shortReservationTimes = [0, 1, 2, 3, 4, 5, 6];

const List<String> shortReservationDaysString = [
  '없음',
  '1일',
  '2일',
  '3일',
  '4일',
  '5일',
  '6일',
];
const List<String> depositTimes = [
  '없음',
  '30분',
  '1시간',
  '1시간 30분',
  '2시간',
  '2시간 30분',
  '3시간',
  '3시간 30분',
  '4시간'
];

const List<String> optionTimes = [
  '0분',
  '30분',
  '1시간',
  '1시간 30분',
  '2시간',
  '2시간 30분',
  '3시간',
  '3시간 30분',
  '4시간'
];

const List<int> intMinutesWithoutZero = [1, 2, 3, 4, 5, 6, 7, 8];
const List<String> treatmentTimes = [
  '30분',
  '1시간',
  '1시간 30분',
  '2시간',
  '2시간 30분',
  '3시간',
  '3시간 30분',
  '4시간'
];
