import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/bottom_sheet_header.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_textfield.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_catalog_service.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_select_field.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_selection_sheet.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/location_model.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/widgets/address_info_widget.dart';

class ListingLocationSheet extends StatefulWidget {
  const ListingLocationSheet({
    super.key,
    required this.onSelected,
    required this.initialLocation,
    this.onPickMap,
  });

  final ValueChanged<LocationModel> onSelected;
  final LocationModel? initialLocation;
  final VoidCallback? onPickMap;

  @override
  State<ListingLocationSheet> createState() => _ListingLocationSheetState();
}

class _ListingLocationSheetState extends State<ListingLocationSheet> {
  final ListingCatalogService _catalogService = ListingCatalogService();
  final TextEditingController _streetController = TextEditingController();

  String _country = '';
  String _city = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _country = widget.initialLocation!.country;
      _city = widget.initialLocation!.city;
      _streetController.text = widget.initialLocation!.address;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (_) => FractionallySizedBox(
            heightFactor: 0.9,
            child: ListingSelectionSheet(
              title: 'Country',
              options: _catalogService.getCountryOptions(),
              selectedValue: _country,
              onSelected: (value) => setState(() => _country = value),
            ),
          ),
    );
  }

  void _selectCity() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (_) => FractionallySizedBox(
            heightFactor: 0.9,
            child: ListingSelectionSheet(
              title: 'City',
              options: _catalogService.getCityOptions(_country),
              selectedValue: _city,
              onSelected: (value) => setState(() => _city = value),
            ),
          ),
    );
  }

  Future<void> _submit() async {
    if (_country.isEmpty || _city.isEmpty || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    final street = _streetController.text.trim();
    final addressParts = [
      street,
      _city,
      _country,
    ].where((p) => p.isNotEmpty).join(', ');
    try {
      final locations = await locationFromAddress(addressParts);
      if (locations.isEmpty) {
        throw StateError('No coordinates found');
      }
      final loc = locations.first;
      widget.onSelected(
        LocationModel(loc.latitude, loc.longitude, street, _country, _city),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not find coordinates for this address.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetHeader(
            title: 'Location',
            onClose: () => Navigator.pop(context),
            leading:
                widget.onPickMap == null
                    ? null
                    : GestureDetector(
                      onTap: widget.onPickMap,
                      child: SvgPicture.asset(
                        AppAssets.mapIcon,
                        width: 20,
                        height: 20,
                      ),
                    ),
            leadingSpacing: AppSizes.paddingS,
          ),
          const SizedBox(height: AppSizes.paddingM),
          ListingSelectField(
            label: 'Country',
            value: _country,
            placeholder: 'Choose country',
            onTap: _selectCountry,
          ),
          const SizedBox(height: AppSizes.paddingM),
          ListingSelectField(
            label: 'City',
            value: _city,
            placeholder: 'Choose city',
            onTap: _selectCity,
          ),
          const SizedBox(height: AppSizes.paddingM),
          CustomTextField(
            label: 'Street',
            hintText: 'Enter street name',
            controller: _streetController,
          ),
          const SizedBox(height: AppSizes.paddingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _country.isEmpty || _city.isEmpty || _isSubmitting
                      ? null
                      : _submit,
              child: const Text('Add address'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListingMapSheet extends StatefulWidget {
  const ListingMapSheet({
    super.key,
    required this.onSelected,
    required this.onOpenList,
  });

  final ValueChanged<LocationModel> onSelected;
  final VoidCallback onOpenList;

  @override
  State<ListingMapSheet> createState() => _ListingMapSheetState();
}

class _ListingMapSheetState extends State<ListingMapSheet> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(27.6602292, 85.308027);
  String formattedAddress = 'Location Name:';
  String _streetLine = '';
  String _city = '';
  String _country = '';
  double? lat;
  double? lng;
  double _currentZoom = 12;

  @override
  void initState() {
    super.initState();
    lat = _center.latitude;
    lng = _center.longitude;
    _updateAddress();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    lat = _center.latitude;
    lng = _center.longitude;
    try {
      final placemarks = await placemarkFromCoordinates(lat!, lng!);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        formattedAddress = _formatAddress(p);
        _streetLine = _formatStreet(p);
        _city = _extractCity(p);
        _country = p.country ?? '';
      } else {
        formattedAddress = 'Address not found';
        _streetLine = '';
        _city = '';
        _country = '';
      }
    } catch (_) {
      formattedAddress = 'error getting address';
      _streetLine = '';
      _city = '';
      _country = '';
    }
    if (mounted) setState(() {});
  }

  String _formatStreet(Placemark p) {
    return [
      if (p.subThoroughfare?.isNotEmpty ?? false) p.subThoroughfare,
      if (p.thoroughfare?.isNotEmpty ?? false) p.thoroughfare,
      if (p.subLocality?.isNotEmpty ?? false) p.subLocality,
    ].join(' ').trim();
  }

  String _extractCity(Placemark p) {
    if (p.locality?.isNotEmpty ?? false) return p.locality!;
    if (p.subAdministrativeArea?.isNotEmpty ?? false) {
      return p.subAdministrativeArea!;
    }
    if (p.administrativeArea?.isNotEmpty ?? false) {
      return p.administrativeArea!;
    }
    return '';
  }

  String _formatAddress(Placemark p) {
    return [
      if (p.subThoroughfare?.isNotEmpty ?? false) p.subThoroughfare,
      if (p.subLocality?.isNotEmpty ?? false) p.subLocality,
      if (p.thoroughfare?.isNotEmpty ?? false) p.thoroughfare,
      if (p.postalCode?.isNotEmpty ?? false) p.postalCode,
      if (p.subAdministrativeArea?.isNotEmpty ?? false) p.subAdministrativeArea,
      if (p.administrativeArea?.isNotEmpty ?? false) p.administrativeArea,
      if (p.country?.isNotEmpty ?? false) p.country,
    ].join(', ').trim();
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
    _currentZoom = position.zoom;
  }

  void _onCameraIdle() {
    _updateAddress();
  }

  void _confirm() {
    if (lat == null || lng == null) return;
    final street = _streetLine.isNotEmpty ? _streetLine : formattedAddress;
    widget.onSelected(LocationModel(lat!, lng!, street, _country, _city));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const double markerSize = 84;
    const double addressYOffset = markerSize / 2 + 12;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          BottomSheetHeader(
            title: 'Location',
            onClose: () => Navigator.pop(context),
            leading: IconButton(
              onPressed: widget.onOpenList,
              icon: SvgPicture.asset(
                AppAssets.listViewIcon,
                width: 22,
                height: 22,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          SizedBox(
            height: 543,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: _currentZoom,
                    ),
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                  ),
                  IgnorePointer(
                    child: Stack(
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.mapDetectorSvg,
                            width: markerSize,
                            height: markerSize,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Transform.translate(
                            offset: Offset(0, addressYOffset),
                            child: AddressInfoWindow(address: formattedAddress),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirm,
              child: const Text('Add address'),
            ),
          ),
        ],
      ),
    );
  }
}
