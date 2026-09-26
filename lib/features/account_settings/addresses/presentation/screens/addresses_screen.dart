import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../profile/presentation/widgets/profile_app_bar.dart';
import '../../data/models/addresses_copy.dart';
import '../../data/repositories/address_repository.dart';
import '../../logic/cubit/address_cubit.dart';
import '../../logic/cubit/address_state.dart';
import '../widgets/addresses_state_views.dart';
import '../widgets/saved_addresses_list.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressCubit(repository: AddressRepository()),
      child: const _AddressesScreenView(),
    );
  }
}

class _AddressesScreenView extends StatefulWidget {
  const _AddressesScreenView();

  @override
  State<_AddressesScreenView> createState() => _AddressesScreenViewState();
}

class _AddressesScreenViewState extends State<_AddressesScreenView> {
  String? _dismissedErrorKey;

  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().listenToAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(title: AddressesCopy.listTitle),
              Expanded(
                child: BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                    final hasAddresses = switch (state) {
                      AddressLoaded(:final addresses) => addresses.isNotEmpty,
                      AddressActionInProgress(:final addresses) =>
                        addresses.isNotEmpty,
                      AddressError(:final lastKnownAddresses) =>
                        lastKnownAddresses?.isNotEmpty ?? false,
                      _ => false,
                    };
                    return Column(
                      children: [
                        Expanded(
                          child: switch (state) {
                            AddressInitial() => const SizedBox.shrink(),
                            AddressLoading() => const AddressesLoading(),
                            AddressEmpty() => const EmptyAddressesView(),
                            AddressLoaded(:final addresses) =>
                              SavedAddressesList(addresses: addresses),
                            AddressActionInProgress(:final addresses)
                                when addresses.isEmpty =>
                              const SizedBox.shrink(),
                            AddressActionInProgress(:final addresses) =>
                              SavedAddressesList(
                                addresses: addresses,
                                isRefreshing: true,
                              ),
                            AddressError(:final message, :final lastKnownAddresses)
                                when lastKnownAddresses?.isNotEmpty ?? false =>
                              SavedAddressesList(
                                addresses: lastKnownAddresses!,
                                errorMessage: message,
                                showErrorBanner: message != _dismissedErrorKey,
                                onDismissError: () => setState(
                                  () => _dismissedErrorKey = message,
                                ),
                              ),
                            AddressError(:final message) =>
                              AddressesErrorView(message: message),
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.spacingLg,
                            AppDimensions.spacingXl,
                            AppDimensions.spacingLg,
                            AppDimensions.spacingLg,
                          ),
                          child: AddAddressButton(
                            label: hasAddresses
                                ? AddressesCopy.addAddressNew
                                : AddressesCopy.addAddress,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}