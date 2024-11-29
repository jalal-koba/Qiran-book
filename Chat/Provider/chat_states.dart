abstract class ChatStates {}

class InitialState extends ChatStates {}

class ChatLoadingState extends ChatStates {}

class ChatSuccessState extends ChatStates {}

class ChatErrorState extends ChatStates {
  final String message;

  ChatErrorState({required this.message});
}

class SendTextLoadingState extends ChatStates {}

class SendTextSuccessState extends ChatStates {}

class SendTextErrorState extends ChatStates {}

//  refresh states

class AutoRefreshLoadingState extends ChatStates {}

class AutoRefreshSuccessState extends ChatStates {}

class AutoRefreshErrorState extends ChatStates {}
