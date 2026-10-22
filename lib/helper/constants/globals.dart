import 'package:event_bus/event_bus.dart';
import 'package:grocipe/helper/utils/logger.dart';

/// A default instance of [EventBus] shared by the app,
/// this is initialised once and serve as a singleton
/// for broadcasting and listening to events.
EventBus eventBus = EventBus();

///Global logger variable
///usage log("Hello world)
Logger devLog = Logger.instance;
