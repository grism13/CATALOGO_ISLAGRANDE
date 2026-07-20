import 'dart:convert'; 
import 'package:http/http.dart' as http; 

void main() async { 
  final req = http.MultipartRequest('POST', Uri.parse('https://api.imgbb.com/1/upload?key=930febc68f092b09512ebd24c6cd5537')); 
  req.fields['image'] = 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'; 
  final res = await req.send(); 
  print(res.statusCode); 
  print(await res.stream.bytesToString()); 
}
