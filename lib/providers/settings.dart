import 'package:flutter/foundation.dart';
import '../screens/add_meal_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/category_screen.dart';
import '../widget/drawer_tab.dart';

class LanguageSettings with ChangeNotifier {
  Map<String, Map<String, String>> _engWords = {
    'name': {'appName': 'Recipes Notepad'},
    AuthScreen.routeName: {
      'welcome 1': 'welcome to',
      'welcome 2': 'Recipe Notepad',
      'enter your data': 'enter your data',
      'sign in text': 'Sign In',
      'sign up text': 'Sign Up',
      'sign in command': 'SIGNIN',
      'sign up command': 'SIGNUP',
      'sign email': 'e-mail',
      'sign password': 'password',
      'sign confirm': 'confirm password',
      'sign in switch command': 'Sign In insteed',
      'sign up switch command': 'Sign Up insteed',
      'show password command': 'Show Password',
      'email error': 'Please enter valid e-mail',
      'empty password': 'Please provide your password',
      'short password': 'Please provide a password more than 8 characters',
      'confirm error': 'Password doesn\'t match',
    },
    DrawerTab.routeName: {
      'category': 'Categories',
      'add recpie': 'Add Recipe',
      'language switch': 'عربي/eng',
      'Sign Out': 'Sign Out',
    },
    CategoryScreen.routeName: {
      'loading error': 'Error couldn\'t load recipes!!',
      'ok': 'OK'
    },
    AddMealScreen.routeName: {
      'Simple': 'Simple',
      'Challenging': 'Challenging',
      'Hard': 'Hard',
      'Affordable': 'Affordable',
      'Pricey': 'Pricey',
      'Luxurious': 'Luxurious',
      'add new recipe': 'Add New Recipy',
      'recipy name': 'Recipy Name',
      'duration': 'Duration',
      'add duraion': 'please add the duration expected for the recipy',
      'valid duration': 'please enter a valid duration in minutes',
      'photo Link': 'Image Url',
      'add photo link error': 'Please add Image Url for the recipy',
      'add photo Link': 'Enter the recipy\'s Image Url',
      'error': 'Error',
      'Affordability title': 'how affordable it is ',
      'Affordability hint': 'Affordability',
      'Comlexity title': 'how easy to make it ',
      'Comlexity hint': 'Comlexity',
      'recipy category': 'Recipy Category',
      'Ingredients': 'Ingredients',
      'Ingredient': 'Ingredient',
      'max ing. 10': 'max number of Ingredients is 10',
      'add ingredient': 'Add Ingredient',
      'save Ingredient': 'Save Ingredients',
      'steps': 'Steps',
      'step': 'Step',
      'max steps 10': 'max number of Steps is 10',
      'add step': 'Add Step',
      'save steps': 'Save Steps',
      'save': 'Save',
    }
  };
  Map<String, Map<String, String>> _araWords = {
    'name': {'appName': 'مفكرة الوصفات'},
    AuthScreen.routeName: {
      'welcome 1': 'أهلا في',
      'welcome 2': 'مفكر الوصفات',
      'sign in text': 'تسجيل دخول',
      'sign in command': 'سجل دخولي',
      'enter your data': 'ادخل بياناتك',
      'sign up text': 'انشاء حساب',
      'sign up command': 'انشأ حسابي',
      'sign email': 'ايميل',
      'sign password': 'باسورد',
      'sign confirm': 'تأكيد الباسورد',
      'sign in switch command': 'بدل لتسجيل دخول',
      'sign up switch command': 'بدل لإنشاء حساب',
      'show password command': 'اظهر الباسورد',
      'email error': 'أدخل ايميل صحيح',
      'empty password': 'ادخل الباسورد رجاء',
      'short password': 'هذا باسورد قصير ادخل علي الاقل 8 حروف',
      'confirm error': 'غير متطابق',
    },
    DrawerTab.routeName: {
      'category': 'التصنيفات',
      'add recpie': 'إضافة وصفة',
      'language switch': 'عربي/eng',
      'Sign Out': 'تسجيل الخروج',
    },
    CategoryScreen.routeName: {
      'loading error': 'خطأ غير قادر علي تحميل الوصفات',
      'ok': 'حسنا'
    },
    AddMealScreen.routeName: {
      'Simple': 'بسيط',
      'Challenging': 'متوسط',
      'Hard': 'صعب',
      'Affordable': 'رخيص',
      'Pricey': 'متوسط',
      'Luxurious': 'غالي',
      'add new recipe': 'إضافة وصفة جديدة',
      'recipy name': 'إسم الوصفة',
      'duration': 'المدة',
      'add duraion': 'من فضلك اضف المدة التوقعة للوصفة',
      'valid duration': 'من فضلك اضف المدة بالدقائق',
      'photo Link': 'رابط الصورة',
      'add photo link error': 'من فضلك اضف رابط صورة الوصفة',
      'add photo Link': 'أدخل رابط صورة الوصفة',
      'error': 'خطأ',
      'Affordability title': 'ما مستوي التكلفة',
      'Affordability hint': 'التكلفة',
      'Comlexity title': 'ما مستوي سهولتها',
      'Comlexity hint': 'السهولة',
      'recipy category': 'نوع الوصفة',
      'Ingredients': 'مكونات',
      'Ingredient': 'مكون',
      'max ing. 10': 'أقصي عدد من المكونات 10',
      'add ingredient': 'إضافة مكون',
      'save Ingredient': 'حفظ المكونات',
      'steps': 'خطوات',
      'step': 'خطوة',
      'max steps 10': 'أقصي عدد من الخطوات 10',
      'add step': 'إضافة خطوة',
      'save steps': 'إحفظ الخطوات',
      'save': 'إحفظ',
    }
  };

  bool _isEng = true;
  bool get isEng {
    return _isEng;
  }

  Map<String, String> getWords(String routeName) {
    return Map.from(_isEng ? _engWords[routeName] : _araWords[routeName]);
  }

  void setIsEng(bool value) {
    _isEng = value;
    notifyListeners();
  }

  void toogleLanguage() {
    _isEng = !_isEng;
    notifyListeners();
  }
}
