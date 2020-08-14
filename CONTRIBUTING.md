Install vala and valac as well as any additional libraries listed in the meson.build file

Build app Instructions: Move to project src folder
valac --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg json-glib-1.0 --pkg granite Application.vala StockCard.vala GetApiData.vala CardGrid.vala Style.vala Cards.vala Local.vala ApiKey.vala MainPage.vala -X -DGETTEXT_PACKAGE="..."

./Application

New packages must be added to valac command as --pkg newpckg1.0
New vala files must be added as well

Please check the issues tab on GitHub for known issues and features that could be added
