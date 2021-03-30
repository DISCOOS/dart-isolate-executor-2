import 'dart:async';
import 'dart:isolate';
import 'dart:mirrors';

abstract class Executable<T> {
  Executable(this.message) : _sendPort = message["_sendPort"];

  Future<T> execute();

  final Map<String, dynamic> message;
  final SendPort _sendPort;

  U instanceOf<U>(
    String typeName, {
    List positionalArguments: const [],
    Symbol constructorName = const Symbol(""),
    Map<Symbol, dynamic> namedArguments = const <Symbol, dynamic>{},
  }) {
    var typeMirror = currentMirrorSystem().isolate.rootLibrary.declarations[new Symbol(typeName)];
    if (typeMirror is! ClassMirror) {
      typeMirror = currentMirrorSystem()
          .libraries
          .values
          .where((lib) => lib.uri.scheme == "package" || lib.uri.scheme == "file")
          .expand((lib) => lib.declarations.values)
          .firstWhere((decl) => decl is ClassMirror && MirrorSystem.getName(decl.simpleName) == typeName,
              orElse: () => throw new ArgumentError("Unknown type '$typeName'. Did you forget to import it?"));
    }

    return (typeMirror as ClassMirror)
        .newInstance(
          constructorName,
          positionalArguments,
          namedArguments,
        )
        .reflectee as U;
  }

  void send(dynamic message) {
    _sendPort.send(message);
  }

  void log(String message) {
    _sendPort.send({"_line_": message});
  }
}
