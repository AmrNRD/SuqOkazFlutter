class GuardParser{

  static T safeCast<T>(dynamic obj, {bool ignoreNull = true, bool assertResult = false}) {
    if (obj == null) {
      if (!ignoreNull) {
        final error = "safeCast passed in obj is null";
        print(error);
        assert(false, error);
      }
      return null;
    }

    T result = (obj is T) ? obj : null;
    if (result == null && obj != null) {

      if(obj is int && T is String){
        return obj.toString() as dynamic;
      }else if(obj is String && T is int){
        result = int.tryParse(obj) as dynamic;
      }

      if(result == null){
        final error = "safeCast obj:$obj is not of type:${T.runtimeType}";
        print(error);
        if (assertResult) assert(false, error);
      }
    }
    return result;
  }
}
