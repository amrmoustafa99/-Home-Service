import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../profile/presentation/widgets/profile_app_bar.dart';
import '../../data/datasources/location_local_datasource.dart';
import '../../data/models/address_model.dart';
import '../../data/models/addresses_copy.dart';
import '../../data/models/city_model.dart';
import '../../data/models/governorate_model.dart';
import '../../logic/cubit/address_cubit.dart';
import '../../logic/cubit/address_state.dart';
import '../widgets/add_address_form_fields.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, this.existingAddress});

  final AddressModel? existingAddress;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  List<GovernorateModel> _governorates = const [];
  List<CityModel> _cities = const [];
  String? _selectedGovernorateId;
  String? _selectedCityId;
  bool _citiesLoading = false;
  bool _locationsError = false;
  bool _isDefault = false;
  bool _pendingSubmit = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingAddress;
    if (existing != null) {
      _titleController.text = existing.title;
      _detailsController.text = existing.addressDetails;
      _landmarkController.text = existing.landmark ?? '';
      _isDefault = existing.isDefault;
    }
    _loadGovernorates();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _loadGovernorates() async {
    try {
      final governorates =
          await LocationLocalDatasource().loadGovernorates();
      if (!mounted) return;
      setState(() {
        _governorates = governorates;
        _locationsError = false;
      });
      await _preselectExistingAddress(governorates);
    } catch (_) {
      if (!mounted) return;
      setState(() => _locationsError = true);
    }
  }

  Future<void> _preselectExistingAddress(
    List<GovernorateModel> governorates,
  ) async {
    final existing = widget.existingAddress;
    if (existing == null) return;

    final governorate = _firstWhereOrNull(
      governorates,
      (g) => g.nameAr == existing.governorate,
    );
    if (governorate == null) return;

    setState(() {
      _selectedGovernorateId = governorate.id;
      _cities = const [];
      _citiesLoading = true;
    });

    try {
      final cities = await LocationLocalDatasource()
          .loadCitiesForGovernorate(governorate.id);
      if (!mounted || _selectedGovernorateId != governorate.id) return;
      final city = _firstWhereOrNull(
        cities,
        (c) => c.nameAr == existing.city,
      );
      setState(() {
        _cities = cities;
        _citiesLoading = false;
        _selectedCityId = city?.id;
      });
    } catch (_) {
      if (!mounted || _selectedGovernorateId != governorate.id) return;
      setState(() {
        _cities = const [];
        _citiesLoading = false;
      });
    }
  }

  static T? _firstWhereOrNull<T>(
    Iterable<T> items,
    bool Function(T) test,
  ) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  Future<void> _onGovernorateChanged(String? governorateId) async {
    setState(() {
      _selectedGovernorateId = governorateId;
      _selectedCityId = null;
      _cities = const [];
      _citiesLoading = governorateId != null;
    });
    if (governorateId == null) return;

    try {
      final cities = await LocationLocalDatasource()
          .loadCitiesForGovernorate(governorateId);
      if (!mounted || _selectedGovernorateId != governorateId) return;
      setState(() {
        _cities = cities;
        _citiesLoading = false;
      });
    } catch (_) {
      if (!mounted || _selectedGovernorateId != governorateId) return;
      setState(() {
        _cities = const [];
        _citiesLoading = false;
      });
    }
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _pendingSubmit = true;
    final cubit = context.read<AddressCubit>();
    final existing = widget.existingAddress;
    if (existing != null) {
      cubit.updateAddress(
        _buildAddress().copyWith(id: existing.id, isDefault: existing.isDefault),
      );
    } else {
      cubit.addAddress(_buildAddress());
    }
  }

  AddressModel _buildAddress() {
    final governorate = _governorates.firstWhere(
      (g) => g.id == _selectedGovernorateId,
    );
    final city = _cities.firstWhere((c) => c.id == _selectedCityId);
    final landmarkText = _landmarkController.text.trim();
    return AddressModel(
      title: _titleController.text.trim(),
      governorate: governorate.nameAr,
      city: city.nameAr,
      addressDetails: _detailsController.text.trim(),
      landmark: landmarkText.isEmpty ? null : landmarkText,
      isDefault: _isDefault,
      createdAt: DateTime.now(),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<AddressCubit, AddressState>(
        listenWhen: (previous, current) =>
            current is AddressLoaded || current is AddressError,
        listener: (context, state) {
          if (state is AddressLoaded && _pendingSubmit) {
            _pendingSubmit = false;
            _showSnackBar(
              widget.existingAddress != null
                  ? AddressesCopy.updatedSuccessfully
                  : AddressesCopy.savedSuccessfully,
              isError: false,
            );
            Navigator.of(context).pop();
          } else if (state is AddressError && _pendingSubmit) {
            _pendingSubmit = false;
            _showSnackBar(state.message, isError: true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Column(
              children: [
                ProfileHeader(
                  title: widget.existingAddress != null
                      ? AddressesCopy.editAddress
                      : AddressesCopy.addAddress,
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimensions.maxContentWidth,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingXl,
                          vertical: AppDimensions.spacingLg,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AddAddressTextField(
                                label: AddressesCopy.titleLabel,
                                controller: _titleController,
                                validator: (value) =>
                                    Validators.requiredText(
                                  value,
                                  AddressesCopy.titleMissing,
                                ),
                                helperText: AddressesCopy.titleHelper,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: AppDimensions.spacingLg),
                              LocationDropdownField<String>(
                                key: ValueKey(
                                  'governorate-dropdown-$_selectedGovernorateId',
                                ),
                                label: AddressesCopy.governorateLabel,
                                items: _governorateItems,
                                hint: AddressesCopy.governorateHint,
                                initialValue: _selectedGovernorateId,
                                onChanged: _onGovernorateChanged,
                                validator: (value) =>
                                    Validators.requiredText(
                                  value,
                                  AddressesCopy.governorateMissing,
                                ),
                                helperText: _locationsError
                                    ? AddressesCopy.locationsLoadFailed
                                    : null,
                              ),
                              const SizedBox(height: AppDimensions.spacingLg),
                              LocationDropdownField<String>(
                                key: ValueKey(
                                  'city-dropdown-$_selectedGovernorateId-$_selectedCityId',
                                ),
                                label: AddressesCopy.cityLabel,
                                items: _cityItems,
                                hint: AddressesCopy.cityHint,
                                initialValue: _selectedCityId,
                                onChanged: (value) {
                                  setState(() => _selectedCityId = value);
                                },
                                validator: (value) =>
                                    Validators.requiredText(
                                  value,
                                  AddressesCopy.cityMissing,
                                ),
                                enabled: _selectedGovernorateId != null &&
                                    !_citiesLoading,
                                isLoading: _citiesLoading,
                                helperText:
                                    _selectedGovernorateId != null &&
                                            !_citiesLoading &&
                                            _cities.isEmpty
                                        ? AddressesCopy.citiesEmpty
                                        : null,
                              ),
                              const SizedBox(height: AppDimensions.spacingLg),
                              AddAddressTextField(
                                label: AddressesCopy.detailsLabel,
                                controller: _detailsController,
                                validator: (value) =>
                                    Validators.requiredText(
                                  value,
                                  AddressesCopy.detailsMissing,
                                ),
                                hintText: AddressesCopy.detailsHint,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                              ),
                              const SizedBox(height: AppDimensions.spacingLg),
                              AddAddressTextField(
                                label: AddressesCopy.landmarkLabel,
                                controller: _landmarkController,
                                textInputAction: TextInputAction.done,
                              ),
                              if (widget.existingAddress == null) ...[
                                const SizedBox(
                                  height: AppDimensions.spacingLg,
                                ),
                                DefaultToggleRow(
                                  value: _isDefault,
                                  onChanged: (value) {
                                    setState(() => _isDefault = value);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BlocBuilder<AddressCubit, AddressState>(
            buildWhen: (previous, current) =>
                previous is! AddressActionInProgress ||
                current is! AddressActionInProgress,
            builder: (context, state) {
              return SubmitBar(
                label: widget.existingAddress != null
                    ? AddressesCopy.editSubmitLabel
                    : AddressesCopy.submitLabel,
                isBusy: state is AddressActionInProgress,
                onPressed: _submit,
              );
            },
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get _governorateItems =>
      _governorates
          .map(
            (g) => DropdownMenuItem<String>(
              value: g.id,
              child: Text(
                g.nameAr,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList();

  List<DropdownMenuItem<String>> get _cityItems => _cities
      .map(
        (c) => DropdownMenuItem<String>(
          value: c.id,
          child: Text(
            c.nameAr,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
      .toList();
}