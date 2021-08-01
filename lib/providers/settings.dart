import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meals/screens/add_category_screen.dart';
import 'package:meals/screens/category_meal_screen.dart';
import 'package:meals/screens/meal_screen.dart';
import 'package:meals/screens/my_recipes_screen.dart';
import 'package:meals/screens/tabs_screen.dart';
import '../screens/add_recipe_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/category_screen.dart';
import '../widget/drawer_tab.dart';

class LanguageSettings with ChangeNotifier {
  Map<String, Map<String, String>> _engWords = {
    'name': {'appName': 'Recipes Notepad'},
    'recipeTile': {
      'deleting?': 'Deleting ?',
      'check': 'Are you sure ?',
      'delete': 'delete',
      'cancel': 'cancel',
      'errorMsg': 'error could\'t delete this recipe',
    },
    'home': {
      'worning': 'worning',
      'errMsg':
          'can\'t access internet you can still use cashed data but any changes won\'t be saved',
      'ok': 'ok',
    },
    TabsScreen.routeName: {
      'Categories': 'Categories',
      'Favorite': 'Favorite',
    },
    'Favorites': {
      'noFav': 'no Favorite Recipe here yet',
    },
    AuthScreen.routeName: {
      'error': 'error',
      'errMsg': 'error unable to sign in please check your internet connection',
      'welcome 1': 'welcome to',
      'welcome 2': 'Recipe Notepad',
      'sign in command': 'SIGNIN',
    },
    DrawerTab.routeName: {
      'category': 'Categories',
      'add recpie': 'Add Recipe',
      'my recpie': 'My Recipes',
      'language switch': 'عربي/eng',
      'Sign Out': 'Sign Out',
    },
    CategoryScreen.routeName: {
      'noCat': 'add first category',
    },
    CategoryMealsScreen.routeName: {'noRecipe': 'no Recipe here yet'},
    AddCategoryScreen.routeName: {
      'addCat': 'add new category',
      'Title': 'Title',
      'errMsg': 'title can\'t be empty',
      'save': 'save',
    },
    AddMealScreen.routeName: {
      'image section': 'RecipeImage',
      'or': 'or',
      'take pic': 'Take Pic',
      'Simple': 'Simple',
      'Challenging': 'Challenging',
      'Hard': 'Hard',
      'Affordable': 'Affordable',
      'Pricey': 'Pricey',
      'Luxurious': 'Luxurious',
      'unknown': 'unknown',
      'min': 'min',
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
      'Take Pic': 'Take Pic',
      'Pic Image': 'Pic Image',
      'enter url': 'enter url',
      'Image Url': 'Image Url',
    },
    MealScreen.routeName: {
      'errMsg': 'error couldn\'t load recipe',
      'imgErr': 'error',
      'ing': 'Ingredients',
      'steps': 'steps',
      'comments': 'comments',
      'noComment': 'add first comment'
    },
    MyRecipes.routeName: {
      'my Recipes': 'my Recipes',
      'noRecipe': 'you havn\'t added any recipe yet',
    },
    'commentFiled': {'addComment': 'enter your Comment'},
    'commentBox': {
      'errMsg': 'could\'t load the comment',
      'edit': 'edit',
      'delete': 'delete',
      'cancel': 'cancel',
      'warrning': 'delete this comment ?'
    },
  };
  Map<String, Map<String, String>> _araWords = {
    'name': {'appName': 'مفكرة الوصفات'},
    'recipeTile': {
      'deleting?': 'حذف ؟',
      'check': 'هل أنت متأكد ؟',
      'delete': 'حذف',
      'cancel': 'إلغاء',
      'errorMsg': 'خطأ غير قادر علي حذف الوصفة',
    },
    'home': {
      'worning': 'تحذير',
      'errMsg':
          'غير قادر علي الاتصال بالإنترنت يمكنك تصفح الوصفات المحفوظة ولكن لن يتم حفظ اي تغير ',
      'ok': 'حسنا',
    },
    TabsScreen.routeName: {
      'Categories': 'التصنيفات',
      'Favorite': 'المفضلة',
    },
    'Favorites': {
      'noFav': 'لم تضف اي وصفة للمفضلة بعد',
    },
    AuthScreen.routeName: {
      'error': 'خطأ',
      'errMsg': 'خطأ غير قادر علي تسجيل الدخول تأكد من اتصالك بالإنترنت',
      'sign in command': 'سجل دخولي',
      'welcome 1': 'أهلا في',
      'welcome 2': 'مفكرة الوصفات',
      'sign in text': 'تسجيل دخول',
    },
    DrawerTab.routeName: {
      'category': 'التصنيفات',
      'add recpie': 'إضافة وصفة',
      'my recpie': 'وصفاتي',
      'language switch': 'عربي/eng',
      'Sign Out': 'تسجيل الخروج',
    },
    CategoryScreen.routeName: {
      'noCat': 'أضف أول تصنيف',
    },
    CategoryMealsScreen.routeName: {'noRecipe': 'لا يوجد وصفات هنا بعد'},
    AddCategoryScreen.routeName: {
      'addCat': 'إضافة فئة جديدة',
      'Title': 'إسم الفئة',
      'errMsg': 'إسم الفئة لا يمكن ان يكون خالي',
      'save': 'إحفظ',
    },
    AddMealScreen.routeName: {
      'image section': 'صورة الوصفة',
      'or': 'أو',
      'take pic': 'ألتقط صورة',
      'Simple': 'بسيط',
      'Challenging': 'متوسط',
      'Hard': 'صعب',
      'Affordable': 'رخيص',
      'Pricey': 'متوسط',
      'Luxurious': 'غالي',
      'unknown': 'غير معروف',
      'add new recipe': 'إضافة وصفة جديدة',
      'recipy name': 'إسم الوصفة',
      'duration': 'المدة',
      'add duraion': 'من فضلك اضف المدة التوقعة للوصفة',
      'valid duration': 'من فضلك اضف المدة بالدقائق',
      'photo Link': 'رابط الصورة',
      'add photo link error': 'من فضلك اضف رابط صورة الوصفة',
      'add photo Link': 'أدخل رابط صورة الوصفة',
      'error': 'خطأ',
      'min': 'دقيقة',
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
      'Take Pic': 'أخذ صورة',
      'Pic Image': 'اختيار صورة',
      'enter url': 'اضف رابط',
      'Image Url': 'رابط الصورة',
    },
    MealScreen.routeName: {
      'errMsg': 'خطأ غير قابل علي تحميل الوصفة',
      'imgErr': 'خطأ',
      'ing': 'المكونات',
      'steps': 'الخطوات',
      'comments': 'التعليقات',
      'noComment': 'أضف أول تعليق'
    },
    MyRecipes.routeName: {
      'my Recipes': 'وصفاتي',
      'noRecipe': 'أنت لم تطف أي وصفة بعد',
    },
    'commentFiled': {'addComment': 'أضف تغليقك'},
    'commentBox': {
      'errMsg': 'غير قادر علي حذف التعليق',
      'edit': 'تعديل',
      'delete': 'حذف',
      'cancel': 'إلغاء',
      'warrning': 'حذف هذا التعليق ؟'
    },
  };

  bool _isEng = true;
  bool _init = true;

  bool get isEng {
    if (_init) {
      getIsEng();
      _init = false;
    }
    return _isEng;
  }

  void getIsEng() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs == null)
      _isEng = false;
    else if (prefs.getBool('isEng') == null) {
      setIsEng(false);
      _isEng = false;
    } else
      _isEng = prefs.getBool('isEng');
    print('====loading saved settings: $_isEng prefs: $prefs');
    notifyListeners();
  }

  Map<String, String> getWords(String routeName) {
    return Map.from(
      _isEng ? _engWords[routeName] : _araWords[routeName],
    );
  }

  void setIsEng(bool value) async {
    _isEng = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool('isEng', value);
    print('====set saved settings: $_isEng');
  }

  void toogleLanguage() async {
    _isEng = !_isEng;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool('isEng', _isEng);
    print('====set saved settings: $_isEng');
  }
}
