import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:get/get.dart';
import 'package:reg_page/src/auth/controllers/user_controller.dart';
import 'package:reg_page/src/auth/screens/country.dart';
import 'package:reg_page/src/auth/screens/login_screen.dart';
import 'package:reg_page/src/constant.dart';

class StartRegisterScreen extends GetView<UserController> {
  const StartRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 50,
          top: 25,
          left: kBodyHrPadding,
          right: kBodyHrPadding,
        ),
        child: JHGPrimaryBtn(
          label: 'Next',
          onPressed: () => controller.completeRegister(),
        ),
      ),
      body: JHGBody(
        padding: EdgeInsets.symmetric(
          horizontal: JHGResponsive.isMobile(context)
              ? 0
              : JHGResponsive.isTablet(context)
                  ? MediaQuery.sizeOf(context).width * .25
                  : MediaQuery.sizeOf(context).width * .30,
        ),
        body: Form(
          key: controller.starRegFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: height * .1),
              Text(
                'Step 1 - Your Details',
                style: JHGTextStyles.lrlabelStyle.copyWith(fontSize: 29),
              ),
              SizedBox(height: height * .03),
              Text(
                Constant.registerDesc,
                style: JHGTextStyles.subLabelStyle.copyWith(fontSize: 14),
              ),
              // Text(
              //   'Complete Profile',
              //   style: JHGTextStyles.lrlabelStyle.copyWith(fontSize: 29),
              // ),
              // SizedBox(height: height * .03),
              // Text(
              //   'Your journey begins here – complete your profile to get started.',
              //   style: JHGTextStyles.subLabelStyle.copyWith(fontSize: 14),
              // ),
              SizedBox(height: height * .05),
              // const Spacer(),
              JHGTextFormField(
                label: 'First Name',
                controller: controller.fNameC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Last Name',
                validator: (String? val) {
                  return null;
                },
                controller: controller.lNameC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              SearchDropDown(
                items: Contact.countries.map((e) => e.name).toList(),
                // value: Contact.countries.first.name,
                hint: 'Select Country',
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
                    'Already have an account? ',
                    style: JHGTextStyles.btnLabelStyle
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(
                      'Login',
                      style: JHGTextStyles.btnLabelStyle
                          .copyWith(color: JHGColors.primary),
                    ),
                  )
                ],
              ),

              // const Spacer(),
              // SizedBox(height: height * .2),
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
              val == '' || val == null ? 'This field is required' : null,
          hintText: hint,
          decoration: CustomDropdownDecoration(
            closedFillColor: closedColor ?? JHGColors.darkGray,
            expandedFillColor: expandedColor ?? JHGColors.charcolGray,
            listItemStyle: style,
            searchFieldDecoration: SearchFieldDecoration(
              fillColor: JHGColors.secondryBlack,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusValue),
                  borderSide: const BorderSide(color: JHGColors.boxBorder)),
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
          initialItem: value, //?? (items != null ? items!.first : '1'),
          items: items,
          onChanged:
              onChanged != null ? (T? newValue) => onChanged!(newValue) : null,
        ),
      ],
    );
  }
}
