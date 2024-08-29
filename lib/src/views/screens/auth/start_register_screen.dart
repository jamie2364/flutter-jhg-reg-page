import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/models/country.dart';
import 'package:reg_page/src/utils/navigate/nav.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 600;
    controller.clearFields();
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 50,
          top: 25,
          left: kBodyHrPadding,
          right: kBodyHrPadding,
        ),
        child: JHGPrimaryBtn(
          label: Constants.next,
          onPressed: () {
            controller.completeRegister(context);
          },
        ),
      ),
      body: JHGBody(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? kBodyHrPadding
              : MediaQuery.of(context).size.width * (isMobile ? 0.25 : 0.30),
        ),
        body: Form(
          key: controller.starRegFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Heading(text: Constants.step1YourDetails, height: height),
              // Text(

              //   style: JHGTextStyles.lrlabelStyle.copyWith(fontSize: 29),
              // ),
              SizedBox(height: height * .03),
              Text(
                Constants.registerDesc,
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
                    onTap: () {
                      Nav.to(const LoginScreen(isAppLogin: true));
                    },
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
                iconData: Icons.close,
                onTap: onClear,
              ),
              prefixIcon: const Icon(
                Icons.search,
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
                const Icon(Icons.arrow_drop_down, color: JHGColors.white),
            expandedSuffixIcon:
                const Icon(Icons.arrow_drop_up_rounded, color: JHGColors.white),
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
