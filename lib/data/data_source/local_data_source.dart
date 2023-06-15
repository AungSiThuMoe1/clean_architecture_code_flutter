import '../network/error_handler.dart';
import '../responses/responses.dart';
const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60 * 1000; // 1 Minute
abstract class LocalDataSource {
  Future<HomeResponse> getHome();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImplementer implements LocalDataSource{

  //run time cache
  Map<String,CachedItem> cacheMap = Map();
  @override
  Future<HomeResponse> getHome() async{
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];
    if(cachedItem !=null && cachedItem.isValid(CACHE_HOME_INTERVAL)) {
      //return the response from cache
      return cachedItem.data;
    }
    else{
      // return error that cache is not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async{
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
   cacheMap.remove(key);
  }

}

class CachedItem{
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem{
  bool isValid(int expirationTime){
    int currentTimeinMillis =  DateTime.now().millisecondsSinceEpoch;
    bool isCacheValid = currentTimeinMillis - expirationTime < cacheTime;
    
    return isCacheValid;
  }
}