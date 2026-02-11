import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_template/features/counter/presentation/bloc/counter_page_bloc.dart';
import 'package:sizer/sizer.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      floatingActionButton: BlocBuilder<CounterPageBloc, CounterPageState>(
        builder: (context, state) {
          return FloatingActionButton(
              onPressed: (state is CounterPageLoadingSuccess) ?
                  () {
                  context.read<CounterPageBloc>().add(
                      CounterPageIncrementAndUploadStarted(counterEntity: state.counterEntity));
                }
              : null,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
        },
      ),
      body: BlocConsumer<CounterPageBloc, CounterPageState>(
        listener: (context, state) {
          if (state case CounterPageIncrementAndUploadSuccess()) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Increment and upload success'),
                  backgroundColor: Colors.green,
                ));
          } else if (state case CounterPageIncrementAndUploadFailure()) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Increment and upload failure'),
                  backgroundColor: Colors.red,
                ));
          }
        },
        builder: (context, state) {
          if (state case CounterPageInitial()) {
            context.read<CounterPageBloc>().add(CounterPageLoadingStarted());
          } else if (state case CounterPageLoadingInProgress()) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    value: null,
                  ),
                  const Text('Loading'),
                ],
              ),
            );
          } else if (state case CounterPageLoadingSuccess()) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Count: ${state.counterEntity.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          } else if (state case CounterPageLoadingFailure()) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
