[StableKernel](https://stablekernel.com/) has
[discontinued Aqueduct](https://stablekernel.com/article/announcing-the-sunsetting-of-aqueduct-our-open-source-server-side-framework-in-googles-dart/), 
along other packages which aqueduct depends on. This [package](https://github.com/DISCOOS/dart-isolate-executor-2) 
is a fork maintained by [DISCO Open Source](https://discoos.org).

# isolate_executor_2

This library contains types that allow for executing code in a spawned isolate, perhaps with additional imports.

Subclass `Executable` and override its `execute` method. Invoke `IsolateExecutor.executeWithType`, passing in that subclass.
The code in `execute` will run in another isolate. Any value it returns will be returned by `IsolateExecutor.executeWithType`.

A returned value must be a primitive type (anything that is encodable as JSON). You may pass parameters to the other isolate by providing
a message map. 

Example:

```dart
class Echo extends Executable {
  Echo(Map<String, dynamic> message)
      : echoMessage = message['echo'],
        super(message);

  final String echoMessage;

  @override
  Future<dynamic> execute() async {
    return echoMessage;
  }
}

Future main() async {
    final result = await IsolateExecutor.executeWithType(Echo, message: {'echo': 'hello'});
    assert(result == 'hello');
}
``` 