import 'package:http/http.dart' as http;

const String _baseUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';
const int _totalQuizzes = 99;

String get url => _baseUrl;
int get totalQuizzes => _totalQuizzes;

Future<bool> validateURL() async
{
  try{
    var url = Uri.parse(_baseUrl);
    var response = await http.get(url);

    if(response.statusCode != 200)
    {
      return false;
    }

    return true;
  }catch(e){
    return false;
  }

}
