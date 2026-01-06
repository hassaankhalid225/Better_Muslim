import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prayer_log.dart';
import '../../domain/usecases/log_prayer.dart';
import '../../domain/usecases/get_prayer_logs.dart';
import '../../domain/usecases/update_prayer_status.dart';
import 'prayer_event.dart';
import 'prayer_state.dart';

/// Prayer BLoC
/// Manages the state and business logic for Prayer Tracking feature
/// Follows BLoC pattern for separation of concerns
class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final LogPrayer logPrayerUseCase;
  final GetPrayerLogs getPrayerLogsUseCase;
  final UpdatePrayerStatus updatePrayerStatusUseCase;

  PrayerBloc({
    required this.logPrayerUseCase,
    required this.getPrayerLogsUseCase,
    required this.updatePrayerStatusUseCase,
  }) : super(const PrayerInitial()) {
    // Register event handlers
    on<LoadPrayerLogsEvent>(_onLoadPrayerLogs);
    on<LogPrayerEvent>(_onLogPrayer);
    on<UpdatePrayerStatusEvent>(_onUpdatePrayerStatus);
    on<RefreshPrayerDataEvent>(_onRefreshPrayerData);
  }

  /// Handle: Load prayer logs for a specific date
  Future<void> _onLoadPrayerLogs(
    LoadPrayerLogsEvent event,
    Emitter<PrayerState> emit,
  ) async {
    try {
      emit(const PrayerLoading());

      final prayerLogs = await getPrayerLogsUseCase(event.date);

      if (prayerLogs.isEmpty) {
        emit(const PrayerEmpty('No prayers logged for this date'));
      } else {
        emit(PrayerLogsLoaded(
          prayerLogs: prayerLogs,
          date: event.date,
        ));
      }
    } catch (e) {
      emit(PrayerError('Failed to load prayer logs: ${e.toString()}'));
    }
  }

  /// Handle: Log a new prayer
  Future<void> _onLogPrayer(
    LogPrayerEvent event,
    Emitter<PrayerState> emit,
  ) async {
    try {
      emit(const PrayerLoading());

      // Create prayer log entity
      final prayerLog = PrayerLog(
        prayerName: event.prayerName,
        prayerDate: DateTime.now(),
        prayerTime: DateTime.now(),
        status: event.status,
        loggedAt: DateTime.now(),
        notes: event.notes,
      );

      // Execute use case
      final id = await logPrayerUseCase(prayerLog);

      // Emit success state
      emit(PrayerLoggedSuccess(
        message: 'Prayer logged successfully!',
        prayerLog: prayerLog.copyWith(id: id),
      ));

      // Reload prayer logs for today
      add(LoadPrayerLogsEvent(DateTime.now()));
    } catch (e) {
      emit(PrayerError('Failed to log prayer: ${e.toString()}'));
    }
  }

  /// Handle: Update prayer status
  Future<void> _onUpdatePrayerStatus(
    UpdatePrayerStatusEvent event,
    Emitter<PrayerState> emit,
  ) async {
    try {
      emit(const PrayerLoading());

      // Execute use case
      await updatePrayerStatusUseCase(event.id, event.status);

      // Emit success state
      emit(const PrayerStatusUpdated('Prayer status updated successfully!'));

      // Reload prayer logs for today
      add(LoadPrayerLogsEvent(DateTime.now()));
    } catch (e) {
      emit(PrayerError('Failed to update prayer status: ${e.toString()}'));
    }
  }

  /// Handle: Refresh prayer data
  Future<void> _onRefreshPrayerData(
    RefreshPrayerDataEvent event,
    Emitter<PrayerState> emit,
  ) async {
    // Reload prayer logs for today
    add(LoadPrayerLogsEvent(DateTime.now()));
  }
}
