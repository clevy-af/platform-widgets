import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'platform_widgets_base.dart';


const SizedBox wSizedBox= SizedBox();

///Displays an [AppBar] for platform.
class PlatformAppBar extends StatelessWidget implements PreferredSizeWidget{
  const PlatformAppBar({
    super.key, this.title,
    this.titleSpacing, this.titleText,
    this.leading, this.onPressedLeadingButton,
    this.actions, this.backgroundColor,
    this.result,double? elevation,
    this.centerTitle = true, this.leadingWidth= false,
    this.hideLeading= false,
  }):
        elevation=elevation??0,
        titleWithCancel=false;
  const PlatformAppBar.titleWithCancel({super.key,required this. titleText,this.backgroundColor}):
        centerTitle=false,
        leadingWidth=false,
        hideLeading=false,
        titleWithCancel=true,
        titleSpacing=null,
        onPressedLeadingButton=null,
        actions=null,
        result=null,
        title=null,
        elevation=0,
        leading=null
  ;
  final Widget? title;
  final bool centerTitle;
  final bool titleWithCancel;
  final bool leadingWidth;
  final double? titleSpacing;
  final String? titleText;
  final bool hideLeading;
  final Widget? leading;
  final VoidCallback? onPressedLeadingButton;
  final List<Widget>? actions;
  final  Color? backgroundColor;
  final dynamic result;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    if(titleWithCancel){
      final String text=titleText!.replaceAll('/', '').replaceAll('-', ' ');
      Widget textWidget=Text(
        text[0].toUpperCase()+text.substring(1),
        style: Theme.of(context).textTheme.bodyMedium,
      );
      Widget cancelWidget= TextButton(onPressed: () { Navigator.pop(context) ;}, child: Text('Cancel'),);
      if(AppSystem.isMaterial) {
        return AppBar(
            automaticallyImplyLeading: false,
            title: textWidget,
            backgroundColor: backgroundColor??Colors.transparent,
            actions: [
              cancelWidget
            ]
        );
      }
      return CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: textWidget,
        backgroundColor: backgroundColor,
        trailing:cancelWidget ,
      );
    }
    if (AppSystem.isMaterial) {
      Widget backButton=PlatformBackButton(
          onPressed: onPressedLeadingButton ?? () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, result);
            }
          });
      return AppBar(
        centerTitle: centerTitle,
        backgroundColor:backgroundColor,
        titleSpacing: titleSpacing,
        elevation: elevation,
        forceMaterialTransparency:true,
        automaticallyImplyLeading: false,
        leadingWidth: leadingWidth ? 35 : null,
        leading: hideLeading ? const SizedBox()
            : leading ?? backButton,
        title: title??(titleText!=null? Text(
          titleText!,
          style: Theme.of(context).textTheme.bodyMedium, ///!.copyWith(color: isDarkTheme?Colors.white:Colors.black),
        ):null),
        bottom: null,
        actions: actions,
      );
    }
    return CupertinoNavigationBar(
      leading: leading??(hideLeading?SizedBox():CupertinoNavigationBarBackButton(
        // color: kAppIsDarkTheme?Colors.white:Colors.black,
        onPressed: ()=>Navigator.pop(context),
      )),
      backgroundColor: backgroundColor??Colors.transparent,
      automaticallyImplyLeading: false,
      brightness: Brightness.dark,
      trailing: actions != null ? Row(
        mainAxisSize: MainAxisSize.min, children: actions??[],) : null,
      middle: title ?? (titleText != null ? Text(titleText!) : null),
    );
  }

  @override
  Size get preferredSize =>  Size(double.infinity, title == null &&titleText == null && hideLeading
      ? min(10, kToolbarHeight / 2)
      : kToolbarHeight);
}

///Displays an [AppBar] for platform with transparency.
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TransparentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
    }
    return const CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      automaticallyImplyMiddle: false,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.zero;
}

///Displays a [TextField] for platform.
class PlatformTextField extends StatelessWidget {
  const PlatformTextField({
    super.key, this.controller,
    this.maxLength, this.focusNode, this.labelText,
    this.hintText, this.autofocus=false, this.onSubmitted,
    this.keyboardType, this.maxLines, this.inputFormatters,
    this.minLines,this.onChanged, this.textAlign, this.style,
    this.hintStyle, this.textCapitalization, this.enableSuggestions=false,
    this.autofillHints, this.contentPadding, this.readOnly, this.fillColor,
    this.prefixIcon, this.borderRadiusAll, this.borderColor, this.scrollPadding, this.prefixText, this.borderRadius, this.focusBorderRadiusAll, this.focusBorderRadius, this.focusBorderColor, this.suffix,
  });
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool enableSuggestions;
  final bool? readOnly;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final String? labelText;
  final String? prefixText;
  final String? hintText;
  final Iterable<String>? autofillHints;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextCapitalization? textCapitalization;
  final EdgeInsets? contentPadding;
  final EdgeInsets? scrollPadding;
  ///if provided, filled will be true and the fill color will be set.
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffix;
  final double? borderRadiusAll;
  ///Defaults to 15.
  final BorderRadius? borderRadius;
  final double? focusBorderRadiusAll;
  final BorderRadius? focusBorderRadius;
  final Color? borderColor;
  final Color? focusBorderColor;
  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return TextField(
        controller: controller,
        readOnly: readOnly??false,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        focusNode: focusNode,
        keyboardType: keyboardType,
        enableSuggestions: enableSuggestions,
        autocorrect: enableSuggestions,
        autofocus: autofocus,
        autofillHints: autofillHints,
        style: style,
        textAlignVertical: TextAlignVertical.top,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization??TextCapitalization.sentences,
        scrollPadding: scrollPadding??const EdgeInsets.all(20),
        decoration: InputDecoration(
          // suffixIcon: suffix,
            border: borderRadiusAll!=null||borderColor!=null?OutlineInputBorder(
              borderRadius:borderRadius??BorderRadius.circular(15),
              borderSide: BorderSide(color: borderColor??Colors.transparent)
            ):InputBorder.none,
            focusedBorder: focusBorderRadiusAll!=null||focusBorderColor!=null?OutlineInputBorder(
                borderRadius:focusBorderRadius??BorderRadius.circular(focusBorderRadiusAll??15),
                borderSide: BorderSide(color: focusBorderColor??Colors.transparent)
            ): borderRadiusAll!=null||borderColor!=null?OutlineInputBorder(
                borderRadius:borderRadius??BorderRadius.circular(borderRadiusAll??15),
                borderSide: BorderSide(color: borderColor??Colors.transparent)
            ):InputBorder.none,
            fillColor: fillColor??Colors.transparent,
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
             labelText: labelText,
             labelStyle: Theme.of(context).textTheme.bodySmall,
            hintText: hintText,
            hintStyle: hintStyle,
            suffix:FocusScope.of(context).hasFocus? suffix:null,//focusNode!=null&&focusNode!.hasFocus?
            filled: fillColor!=null,
            contentPadding:contentPadding?? const EdgeInsets.symmetric(vertical: 3,horizontal: 5)
        ),
        textAlign: textAlign??TextAlign.left,
        onSubmitted: onSubmitted,
      );
    }
    return CupertinoTextField(
      controller: controller,
      readOnly: readOnly??false,
      placeholder: hintText,
      scrollPadding: scrollPadding??const EdgeInsets.all(20),
      placeholderStyle: hintStyle,
      keyboardType: keyboardType,
      padding: contentPadding??const EdgeInsets.all(5),
      autocorrect: enableSuggestions,
      autofillHints: autofillHints,
      maxLines: maxLines,
      maxLength: maxLength,
      minLines: minLines,
      onChanged: onChanged,
      style: style,
      prefix: prefixText!=null?Text(prefixText!):prefixIcon,
      suffix: suffix,
      decoration: BoxDecoration(
        borderRadius:borderRadius??BorderRadius.circular(borderRadiusAll??15),
        border: Border.all(color: borderColor??Colors.transparent),
        color: fillColor,
      ),
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization??TextCapitalization.sentences,
      autofocus: autofocus,
      clearButtonMode: OverlayVisibilityMode.editing,
      textAlign: textAlign??TextAlign.left,
      onSubmitted: onSubmitted,
    );
  }
}


///Displays a SearchTextField for platform.
// class PlatformSearchTextField<T> extends StatelessWidget {
//   const PlatformSearchTextField({
//     super.key, this.controller, this.focusNode, this.suffixTap,
//     this.labelText, this.suffixIcon, this.inputFormatters,
//     this.onSubmitted, required this.suggestionsCallback, this.minWidth,
//     required this.itemBuilder, required this.onSuggestionSelected, this.minChars = 1,
//     this.autoFocus = false, this.enabled = true, this.fillColor, this.textStyle,
//   });
//
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final String? labelText;
//   final TextStyle? textStyle;
//   final Icon? suffixIcon;
//   final VoidCallback? suffixTap;
//   final double? minWidth;
//   final Color? fillColor;
//   final int minChars;
//   final bool autoFocus;
//   final bool enabled;
//   final List<TextInputFormatter>? inputFormatters;
//   final void Function(dynamic)? onSubmitted;
//   final void Function(dynamic) onSuggestionSelected;
//   final FutureOr<Iterable> Function(String) suggestionsCallback;
//   final Widget Function(BuildContext, int) itemBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController textEditingController = controller ??
//         TextEditingController();
//     // final SuggestionsController searchController=SuggestionsController();
//     Widget searchField;
//     if (AppSystem.isCupertino) {
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CupertinoTextField(
//             controller: controller,
//             style: Theme
//                 .of(context)
//                 .textTheme
//                 .bodySmall,
//             autofocus: autoFocus,
//             decoration: BoxDecoration(
//               color: fillColor,
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             focusNode: focusNode,
//             suffix: suffixIcon,
//             // suffixIcon: suffixIcon??const Icon(CupertinoIcons.xmark_circle_fill),
//             // onSuffixTap: suffixTap,
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//             placeholder: labelText,
//             placeholderStyle: Theme
//                 .of(context)
//                 .textTheme
//                 .bodySmall,
//             // itemColor: kFillColor,
//             // minCharsForSuggestions: minChars,
//             // keepSuggestionsOnLoading: false,
//
//             // noItemsFoundBuilder: (context)=>const SizedBox(),
//             // hideSuggestionsOnKeyboardHide: minChars==0,
//             // suggestionsCallback: suggestionsCallback,
//             // itemBuilder: itemBuilder,
//             onChanged: suggestionsCallback,
//
//             onSubmitted: onSubmitted ?? onSuggestionSelected,
//             // onSuggestionSelected: onSuggestionSelected,
//           ),
//           FutureBuilder(
//               future: controller != null
//                   ? suggestionsCallback(controller!.text)
//                   : null,
//               builder: (context, snap) {
//                 if (snap.connectionState == ConnectionState.waiting)
//                   return wSizedBox;
//                 if (snap.data == null) return SizedBox();
//                 return ListView.builder(
//                   itemCount: (snap.data! as Iterable).length,
//                   itemBuilder: itemBuilder,
//                   shrinkWrap: true,
//                 );
//               }
//           ),
//         ],
//       );
//     }
//     else {
//       Widget? suffix;
//       if (suffixTap != null) {
//         suffix = PlatformClick(
//           onTap: suffixTap,
//           tooltip: labelText,
//           child: suffixIcon ?? wSizedBox,
//         );
//       }
//       else {
//         suffix = suffixIcon;
//       }
//       searchField = Autocomplete<T>(
//         fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => PlatformTextField(
//           style: textStyle ?? Theme.of(context).textTheme.bodySmall,
//           controller: textEditingController,
//           focusNode: focusNode,
//           autofocus: autoFocus,
//             borderRadius: BorderRadius.circular(10.0),
//             fillColor: fillColor ,
//             labelText: labelText,
//             suffix: suffix,
//             contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 5, vertical: 5),
//           inputFormatters: inputFormatters,
//           // onSubmitted: onSubmitted,
//         ),
//         optionsBuilder: (v) => suggestionsCallback(v.text),
//         optionsViewBuilder:(context, onSelected, options) => itemBuilder(context,int),
//         onSelected: (dynamic) {
//           onSuggestionSelected(dynamic);
//           textEditingController.clear();
//         },
//       );
//       // }
//       return SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         child: SizedBox(
//           width: minWidth ?? MediaQuery
//               .of(context)
//               .size
//               .width * 0.9,
//           child: searchField,
//         ),
//       );
//     }
//     // }
//   }
// }

///Displays a [Switch] for platform.
class PlatformSwitch extends StatelessWidget {
  final bool switchValue;
  final String switchTitle;
  final String? subtitle;
  final Color? fillColor;
  final ShapeBorder? shape;
  final Function(bool) onChanged;
  const PlatformSwitch({
    super.key,
    required this.switchValue, required this.switchTitle, required this.onChanged,
    this.subtitle, this.fillColor, this.shape,
  });

  @override
  Widget build(BuildContext context) {
    Widget switchWidget;
    if(AppSystem.isCupertino){
      switchWidget= PlatformListTile(
        title: Text(switchTitle,style: Theme.of(context).textTheme.bodySmall,),
        subtitle: subtitle!=null?Text(subtitle!,style: Theme.of(context).textTheme.labelMedium,):null,
        // isThreeLine: subtitle!=null,
        minVerticalPadding: 5,
        trailing: CupertinoSwitch(
          value: switchValue,
          onChanged: onChanged,
          activeColor: Colors.green,
          trackColor: Colors.black,
        ),
      );
    }
    else {
      switchWidget= SwitchListTile(
        value: switchValue,
        title: Text(switchTitle,style: Theme.of(context).textTheme.bodySmall,),
        tileColor: fillColor ,
        subtitle: subtitle!=null?Text(subtitle!,style: Theme.of(context).textTheme.labelMedium,):null,
        activeTrackColor: Colors.green.withAlpha(150),
        activeColor: Colors.green,
        isThreeLine: subtitle!=null,
        shape: shape,
        onChanged: onChanged,
      );
    }
    return switchWidget;

  }
}

///Displays a refresh wrapper for platform.
class PlatformRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final double? displacement;

  const PlatformRefresh({super.key, required this.onRefresh,required this.child, this.displacement});

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        semanticsLabel: 'Loading',
        backgroundColor: Theme.of(context).primaryColor,
        displacement: displacement??40,
        color: Colors.white,
        child: child,
      );
    }
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh:onRefresh,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index)=>child,
            childCount: 1,
          ),
        ),
      ],
    );
  }
}

///Displays a loading indicator for platform.
class PlatformIndicator extends StatelessWidget {
  const PlatformIndicator({
    super.key,  double? radius,
    this.fullScreen=true,this.color,
    this.value, required this.strokeWidth,
  })
      :radius=radius??20;
  final double radius;
  final double? value;
  final double? strokeWidth;
  final bool fullScreen;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Widget loadingIndicator;
    if(AppSystem.isCupertino) {
      loadingIndicator=  CupertinoActivityIndicator(radius: radius,color: color,);
    }
    else {
      loadingIndicator= CircularProgressIndicator(
        color:color,
        strokeWidth: strokeWidth??4,
        value: value,
        backgroundColor: Colors.transparent,
      );

    }
    return loadingIndicator;
  }
}

///Displays an [IconButton] for platform.
class PlatformIconButton extends StatelessWidget {
  const PlatformIconButton({
    super.key, required this.onPressed,
    required this.iconData, this.size,this.rotate=false, this.tooltip, this.color,
  });
  final VoidCallback onPressed;
  final IconData iconData;
  final double? size;
  final Color? color;
  final String? tooltip;
  final bool rotate;

  @override
  Widget build(BuildContext context) {
    Widget icon=Icon(
      iconData,
      color:color,
      size: size,
    );
    if(rotate){
      icon=Transform.rotate(angle: -pi/2,child: icon,);
    }
    if(AppSystem.isMaterial) {
      return  IconButton(
        visualDensity: const VisualDensity(horizontal: -3),
        onPressed:onPressed,
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        icon: icon,
        // padding: EdgeInsets.all(5),
      );
    }
    Widget cupertinoButton= CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: icon,
    );
    if(tooltip!=null){
      return Tooltip(
        message: tooltip,
        child: cupertinoButton,
      );
    }
    return cupertinoButton;
  }
}

///Displays a Button to go to previous route for platform.
class PlatformBackButton extends StatelessWidget {
  const PlatformBackButton({super.key, this.onPressed, this.iconColor, this.style, this.previousPageTitle,});
  final VoidCallback? onPressed;
  final Color? iconColor;
  final ButtonStyle? style;
  final String? previousPageTitle;

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return  BackButton(
        color: iconColor,
        style: style,
        onPressed: onPressed,
      );
    }
    return CupertinoNavigationBarBackButton(
      color: iconColor,
      onPressed: onPressed,
      previousPageTitle:previousPageTitle,
    );
  }
}

///Displays a Button to pop route for platform.
class PlatformCloseButton extends StatelessWidget {
  const PlatformCloseButton({super.key, this.onPressed, this.iconColor,});
  final VoidCallback? onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return  CloseButton(
        onPressed: onPressed,
        color: iconColor,
      );
    }
    return GestureDetector(
      onTap:onPressed?? ()=>Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Cancel',style: Theme.of(context).textTheme.labelSmall?.copyWith(color: iconColor)),
      ),
    );
  }
}

///Displays a [Scaffold] for platform.
class PlatformScaffold extends StatelessWidget {
  const PlatformScaffold({
    super.key, this.resizeToAvoidBottomInset=true,
    required this.body, this.appBar, this.extendBodyBehindAppBar=false,
    this.useSafeAreaBottom=true,
   this.backgroundColor,this.bottomSheet,this.bottomNavigationBar,
    this.extendBody=false, this.bottomSheetInset, this.useSafeAreaTop=true,
    this.drawer,this.faButton
    });
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final bool useSafeAreaBottom;
  final bool useSafeAreaTop;
  final dynamic appBar;
  final Widget body;
  final Color? backgroundColor;
  final Widget? drawer;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? faButton;
  final double? bottomSheetInset;
  @override
  Widget build(BuildContext context) {
      Widget bodyWidget=SafeArea(
        top: useSafeAreaTop,
          bottom:useSafeAreaBottom,//AppSystem.isIOS?:true,
          child: body
      );
    if(AppSystem.isMaterial) {
      return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: backgroundColor,
        body: bodyWidget,
        appBar: appBar,
        drawer: drawer,
        bottomSheet: bottomSheet,
        extendBody: extendBody,
        floatingActionButton: faButton,
        bottomNavigationBar: bottomNavigationBar,
      );
    }
    /// add [isScaffoldThemeDark] config
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      navigationBar: appBar,
      child: bottomSheet!=null||bottomNavigationBar!=null||faButton!=null?
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Expanded(child: bodyWidget),
              if(bottomNavigationBar!=null) Container(
                  color: backgroundColor,
                  child: bottomNavigationBar!
              ),
            ],
          ),
          if(bottomSheet!=null) SizedBox(
              width: MediaQuery.of(context).size.width,
              child: bottomSheet
          ),
          if(faButton!=null) faButton!,
        ],
      ):
      bodyWidget,
    );
  }
}

///Displays an App Wrapper for platform.
class PlatformApp extends StatelessWidget {
  const PlatformApp({
    super.key, this.title='',
    this.navigatorObservers=const[],
    this.debugShowCheckedModeBanner=false,
   this.initialRoute, this.onGenerateRoute,
    this.cupertinoTheme, this.materialTheme,this.materialDarkTheme,this.navigatorKey, this.themeMode= ThemeMode. system,
    });
  final String title;
  final List<NavigatorObserver> navigatorObservers;
  final Route ? Function(RouteSettings)? onGenerateRoute;
  final bool debugShowCheckedModeBanner;
  final String? initialRoute;
  final CupertinoThemeData? cupertinoTheme;
  final ThemeData? materialTheme;
  final ThemeData? materialDarkTheme;
  final ThemeMode? themeMode;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {

    if(AppSystem.isMaterial) {
      return  MaterialApp(
        title:title,
        debugShowCheckedModeBanner: false,
        themeMode:themeMode,//ThemeMode.system
        theme: materialTheme,
        darkTheme: materialDarkTheme,//lightThemeAndroid
        navigatorObservers: navigatorObservers,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        navigatorKey: navigatorKey,
      );
    }
    return  CupertinoApp(
      title:title,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: cupertinoTheme,
      navigatorObservers: navigatorObservers,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: navigatorKey,
    );
  }
}

///Displays a [ListTile] for platform.
class PlatformListTile extends StatelessWidget {
  const PlatformListTile({
    super.key, this.leading,
    this.trailing, this.title, this.onTap, this.subtitle,
    this.onLongPress, this.contentPadding, this.minVerticalPadding,
    this.visualDensity, this.horizontalTitleGap, this.minLeadingWidth,
    this.enabled, this.backgroundColor=Colors.transparent, this.borderRadius,
  });
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? contentPadding;
  final double? minVerticalPadding;
  final VisualDensity? visualDensity;
  final double? horizontalTitleGap;
  final double? minLeadingWidth;
  final bool? enabled;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial){
      return Material(
        color: backgroundColor,
        child: ListTile(
          leading: leading,
          trailing: trailing,
          title: title,
          onTap: onTap,
          shape:borderRadius!=null? RoundedRectangleBorder(borderRadius: borderRadius!):null,
          visualDensity:  visualDensity,
          horizontalTitleGap: horizontalTitleGap,
          minVerticalPadding: minVerticalPadding,
          contentPadding: contentPadding,
          minLeadingWidth: minLeadingWidth,
          enabled: enabled??true,
          subtitle: subtitle,
          onLongPress: onLongPress,
        ),
      );
    }
    Row rowWidget=Row(
      //mainAxisSize: MainAxisSize.min,
      children: [
        leading??const Spacer(),
       if(leading!=null) const SizedBox(width: 5,),
        title??const Spacer(),
        const Spacer(),
        trailing??const Spacer(),
      ],
    );
    return GestureDetector(
      onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          padding: contentPadding??const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
          child: subtitle!=null?Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              rowWidget,
              subtitle!,
            ],
          )
              :rowWidget,
        ),
    );
  }
}

///Displays a [Button] for platform.
class PlatformClick extends StatelessWidget {
  const PlatformClick({
    super.key, required this.child, this.onTap,
    this.onDoubleTap, this.borderRadius, this.isTapTransparent, this.tooltip,
  });
   final Widget child;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final double? borderRadius;
  final bool? isTapTransparent;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    // final isTransparent=isTapTransparent;
    Widget childW=child;
    if(tooltip!=null) {
      childW=Tooltip(message: tooltip!, child: child);
    }
    if(AppSystem.isMaterial){
      return InkWell(
        onTap: onTap,onDoubleTap: onDoubleTap,
        splashColor: isTapTransparent==true?Colors.transparent:null,
        hoverColor: isTapTransparent==true?Colors.transparent:null,
        overlayColor: isTapTransparent==true?MaterialStateProperty.all(Colors.transparent):null,
        highlightColor: isTapTransparent==true?Colors.transparent:null,
        focusColor: isTapTransparent==true?Colors.transparent:null,
        child: childW,
      );
    }
    //todo check if cupertino button with transparent color is better fit.
    return GestureDetector(onTap: onTap,onDoubleTap: onDoubleTap,child: childW,);
  }
}

///Displays an [TabBar] for platform.
class PlatformTabBar extends StatelessWidget {
  const PlatformTabBar({
    super.key, required this.tabs,
    this.controller, this.childController,
    this.indicatorSize, this.indicator,
    this.unselectedLabelColor, this.tabIndex=0, this.indicatorColor
  });
  final List<String> tabs;
  final int tabIndex;
  final TabController? controller;
  final ValueNotifier<int>? childController;
  final TabBarIndicatorSize? indicatorSize;
  final BoxDecoration? indicator;
  final Color? indicatorColor;
  final Color? unselectedLabelColor;//todo splashcolor?

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return TabBar(
        tabs:List.generate(tabs.length,
              (index) => Tab(
                child: Text(tabs[index],maxLines: 1,overflow: TextOverflow.ellipsis,),
              ),
        ),
        controller: controller,
        indicatorSize: indicatorSize??TabBarIndicatorSize.tab,
        indicator: indicator,
        indicatorColor:indicatorColor,
        labelColor: Colors.white,
        dividerColor: Colors.transparent,
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
        labelStyle: Theme.of(context).textTheme.bodySmall,
        unselectedLabelColor: unselectedLabelColor,
      );
    }
    Map<String,Widget> children={};
    for (var tab in tabs) {
      children.putIfAbsent(tab, () {
        final text= Text(tab);
        if(AppSystem.isCupertino) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
            child: text,
          );
        }
        return text;
      });
    }
    if(childController==null) return wSizedBox;

    return ValueListenableBuilder<int>(
        valueListenable: childController!,
        builder: (context,selected,_) {
        return CupertinoSlidingSegmentedControl<String>(
          children: children,
          // unselectedColor: Colors.white,
          // borderColor: indicatorColor,
          // selectedColor: cPrimary,
          padding: const EdgeInsets.all(5),
          groupValue:tabs[selected],
            // pressedColor: Colors.transparent,
            onValueChanged: (String? value) {
            if(value==null) return;
             childController?.value= tabs.indexOf(value);
            },
          //borderColor: Colors.transparent,
          //unselectedColor: unselectedLabelColor,
        );
      }
    );
  }
}

///Displays a [TabBarView] for platform.
///To be used in conjunction with [PlatformTabBar].
class PlatformTabBarView extends StatelessWidget {

  const PlatformTabBarView({
    super.key, required this.children,
    this.controller,
    this.childController});
  final List<Widget> children;
  final TabController? controller;
  final ValueNotifier<int>? childController;

  @override
  Widget build(BuildContext context) {
    if(AppSystem.isMaterial) {
      return TabBarView(
        physics: const RangeMaintainingScrollPhysics(),
        controller: controller,
        children: children,
      );
    }
    if(childController==null) return wSizedBox;
    return ValueListenableBuilder<int>(
      valueListenable: childController!,
      builder: (context,selected,_) {
        return AnimatedSwitcher(duration: kThemeAnimationDuration,child: children[selected]);
      }
    );
  }
}