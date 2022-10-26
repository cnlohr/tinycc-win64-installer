NSIS:="C:\Program Files (x86)\NSIS\makensis"
TCC_VERSION:=tcc-0.9.27
INSTALLER:=$(TCC_VERSION)-win64-installer.exe
NSIS_SCRIPT:=$(TCC_VERSION)-win64-installer.nsi
NSIS_HEADER:=tcc-installer-header.nsh

all : $(INSTALLER)

$(INSTALLER) : $(NSIS_SCRIPT) $(NSIS_HEADER)
	$(NSIS) $(NSIS_SCRIPT)

InstallData/README.txt : 
	mkdir -p InstallData
	mkdir -p TempDir
	wget -nc http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27-win64-bin.zip
	wget -nc http://download.savannah.gnu.org/releases/tinycc/winapi-full-for-0.9.27.zip
	unzip -o tcc-0.9.27-win64-bin.zip -d TempDir
	unzip -o winapi-full-for-0.9.27.zip -d TempDir
	cp -va TempDir/tcc/* InstallData/
	cp -va TempDir/winapi-full-for-0.9.27/include/* InstallData/include/
	cp -v INSTALLED_README.txt InstallData/README.txt

$(NSIS_HEADER) : InstallData/README.txt
	echo "!define TCC_VERSION $(TCC_VERSION)" > $@
	echo "!define INSTALLER $(INSTALLER)" >> $@

wash :
	rm -rf $(NSIS_HEADER)

clean :
	rm -rf $(INSTALLER) $(NSIS_HEADER) InstallData TempDir tcc-0.9.27-win64-bin.zip winapi-full-for-0.9.27.zip
