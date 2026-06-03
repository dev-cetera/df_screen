// Demonstrates df_screen integration with df_router. Every Screen carries a
// typed RouteState via the RouteWidgetMixin contract, so query parameters
// and "extra" payloads flow into the screen through the router with full
// type safety.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return RouteManager(
          fallbackRouteState: HomeRouteState.new,
          builders: [
            RouteBuilder(
              routeState: HomeRouteState(),
              builder: (context, state) => HomeScreen(routeState: state),
            ),
            RouteBuilder(
              routeState: ChatRouteState(),
              builder: (context, state) {
                return ChatScreen(
                  routeState: ChatRouteState.from(state),
                );
              },
            ),
          ],
          wrapper: (context, child) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    const ScreenBreadCrumbBar(),
                    Expanded(child: child),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ░░░ HOME ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class HomeRouteState extends RouteState {
  HomeRouteState() : super.parse('/home');
}

base class HomeScreen extends Screen {
  const HomeScreen({super.key, super.routeState});

  @override
  State createState() => _HomeState();
}

base class _HomeState extends ScreenState<HomeScreen, ScreenController> {
  @override
  Widget buildWidget(BuildContext context) {
    final router = RouteController.of(context);
    return Center(
      child: ElevatedButton(
        onPressed: () => router.push(ChatRouteState(chatId: '42')),
        child: const Text('Open chat #42'),
      ),
    );
  }
}

// ░░░ CHAT ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class ChatRouteState extends RouteState {
  ChatRouteState({String? chatId})
      : super.parse(
          '/chat',
          queryParameters: {if (chatId != null) 'chatId': chatId},
        );

  ChatRouteState.from(RouteState other) : super(other.uri);

  String? get chatId => uri.queryParameters['chatId'];
}

base class ChatScreen extends Screen {
  const ChatScreen({super.key, super.routeState});

  ChatRouteState get chat => routeState! as ChatRouteState;

  @override
  State createState() => _ChatState();
}

base class _ChatState extends ScreenState<ChatScreen, ScreenController> {
  @override
  Widget buildWidget(BuildContext context) {
    final router = RouteController.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chat ID: ${widget.chat.chatId ?? "(none)"}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => router.goBackward(),
            child: const Text('Back home'),
          ),
        ],
      ),
    );
  }
}
