# stocks
A simple stocks app for Elementary OS
Vala

install vala and valac as well as any additional libraries (more in depth instructions to come on this)

build app
move to project src folder
valac --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg json-glib-1.0 Application.vala  StockCard.vala GetApiData.vala CardGrid.vala Style.vala -X -DGETTEXT_PACKAGE='...' 
./Application

new packages must be added to valac command as --pkg newpckg1.0
new vala files must be added as well
