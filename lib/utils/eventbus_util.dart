import 'package:event_bus/event_bus.dart';

import '../entity/history.dart';

final EventBus eventBus = EventBus();

class HistoryEvent {
  HistoryEntity? history;

  HistoryEvent(this.history);
}

class ChoseEvent {
  List<int> choseIds;

  ChoseEvent(this.choseIds);
}
