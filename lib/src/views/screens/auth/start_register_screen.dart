import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/models/country.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

import '../../../utils/url/urls.dart';

class StartRegisterScreen extends StatefulWidget {
  const StartRegisterScreen({super.key});

  @override
  State<StartRegisterScreen> createState() => _StartRegisterScreenState();
}

class _StartRegisterScreenState extends State<StartRegisterScreen> {
  late UserController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: JHGColors.primaryBlack,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 50,
          top: 25,
          left: Utils.screenHrPadding(context),
          right: Utils.screenHrPadding(context),
        ),
        child: JHGPrimaryBtn(
          label: Constants.next,
          onPressed: () => controller.completeRegister(),
        ),
      ),
      body: JHGBody(
        bodyAppBar: JHGAppBar(
          autoImplyLeading: false,
          trailingWidget: JHGIconButton(
            iconData: LucideIcons.logOut300,
            enabled: true,
            childPadding: const EdgeInsets.all(4),
            onTap: () => Utils.logOut(context),
          ),
        ),
        padding:
            EdgeInsets.symmetric(horizontal: Utils.screenHrPadding(context)),
        body: Form(
          key: controller.starRegFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Heading(text: Constants.step1YourDetails, height: height),
              SizedBox(height: height * .03),
              Text(
                Constants.registerDesc(Urls.base.isEqual(Urls.evoloUrl)
                    ? Constants.evolo
                    : Constants.musictools),
                style: JHGTextStyles.subLabelStyle.copyWith(fontSize: 14),
              ),
              SizedBox(height: height * .05),
              JHGTextFormField(
                label: Constants.firstName,
                controller: controller.fNameC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: Constants.lastName,
                controller: controller.lNameC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              SearchDropDown(
                items: Contact.countries.map((e) => e.name).toList(),
                hint: Constants.selectCountry,
                onChanged: (country) {
                  controller.selectedCountry = country;
                },
                closedHeaderPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              ),
              SizedBox(height: height * .06),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${Constants.alreadyAccount} ',
                    style: JHGTextStyles.btnLabelStyle
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  InkWell(
                    onTap: () => Nav.to(const LoginScreen(isAppLogin: true)),
                    child: Text(
                      Constants.logIn,
                      style: JHGTextStyles.btnLabelStyle
                          .copyWith(color: JHGColors.primary),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDropDown<T> extends StatelessWidget {
  const SearchDropDown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.closedColor,
    this.expandedColor,
    this.hint,
    this.label,
    this.closedHeaderPadding =
        const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
  });

  final T? value;
  final String? hint;
  final List<T>? items;
  final Color? closedColor;
  final Color? expandedColor;
  final String? label;
  final EdgeInsets closedHeaderPadding;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(overflow: TextOverflow.ellipsis, color: JHGColors.whiteText);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(label!, style: JHGTextStyles.btnLabelStyle),
          ),
        CustomDropdown<T>.search(
          closedHeaderPadding: closedHeaderPadding,
          validator: (val) =>
              val == '' || val == null ? Constants.thisFieldIsRequired : null,
          hintText: hint,
          decoration: CustomDropdownDecoration(
            closedFillColor: closedColor ?? JHGColors.darkGray,
            expandedFillColor: expandedColor ?? JHGColors.charcolGray,
            listItemStyle: style,
            searchFieldDecoration: SearchFieldDecoration(
              fillColor: JHGColors.secondryBlack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadiusValue),
                borderSide: const BorderSide(color: JHGColors.boxBorder),
              ),
              textStyle: JHGTextStyles.subLabelStyle,
              suffixIcon: (onClear) => JHGIconButton(
                iconData: LucideIcons.x300,
                onTap: onClear,
              ),
              prefixIcon: const Icon(
                LucideIcons.search300,
                color: JHGColors.white,
              ),
              constraints: const BoxConstraints(),
              hintStyle: JHGTextStyles.subLabelStyle,
            ),
            listItemDecoration: const ListItemDecoration(
              highlightColor: JHGColors.primary,
              selectedColor: JHGColors.primary,
              splashColor: JHGColors.primary,
            ),
            closedSuffixIcon:
                const Icon(LucideIcons.chevronDown300, color: JHGColors.white),
            expandedSuffixIcon:
                const Icon(LucideIcons.chevronUp300, color: JHGColors.white),
            headerStyle: style,
          ),
          initialItem: value,
          items: items,
          onChanged:
              onChanged != null ? (T? newValue) => onChanged!(newValue) : null,
        ),
      ],
    );
  }
}
