import 'package:flutter/material.dart';
import 'package:flutter_advance_mvvm/data/mapper/mapper.dart';
import 'package:flutter_advance_mvvm/presentation/common/state_renderer/state_renderer.dart';
import 'package:flutter_advance_mvvm/presentation/resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

//Loading state (PopUp, Full Screen)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading;

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRendererType() {
    return stateRendererType;
  }
}

//error state (PopUp, Full Screen)

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRendererType() {
    return stateRendererType;
  }
}

// Content State
class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() {
    return EMPTY;
  }

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.CONTENT_SCREEN_STATE;
  }
}

// EMPTY State
class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.EMPTY_SCREEN_STATE;
  }
}

// SUCCESS State
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.POPUP_SUCCESS_STATE;
  }
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (this.runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
            showPopUp(context, getStateRendererType(), getMessage());
            return contentScreenWidget;
          } else //StateRendererType.FULL_SCREEN_LOADING_STATE
          {
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
            showPopUp(context, getStateRendererType(), getMessage());
            return contentScreenWidget;
          } else //StateRendererType.FULL_SCREEN_ERROR_STATE
          {
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case SuccessState:
        {
          dismissDialog(context);
          showPopUp(context, getStateRendererType(), getMessage(),
              title: AppStrings.success);
          return contentScreenWidget;
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: retryActionFunction,
          );
        }
      default:
        {
          return contentScreenWidget;
        }
    }
  }

  dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent != true;
  }

  showPopUp(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = EMPTY}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (contenxt) {
          return StateRenderer(
            title: title,
            stateRendererType: stateRendererType,
            message: message,
            retryActionFunction: () {},
          );
        }));
  }
}
