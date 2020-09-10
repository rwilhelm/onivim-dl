EXEC=node onivim-dl
CACHE_DIR=cache
INSTALL_DIR=$(HOME)/.opt/Onivim2

clean:
	$(RM) -r $(CACHE_DIR)

download:
	$(EXEC) download

install: download
	test -d $(INSTALL_DIR) || mkdir -pv $(INSTALL_DIR)
	tar xvzf $(CACHE_DIR)/latest -C $(INSTALL_DIR) --strip-components=1 Onivim2.AppDir
	ln -sf $(INSTALL_DIR)/AppRun ~/.bin/oni2

uninstall:
	@echo $(RM) -r $(INSTALL_DIR)
	@echo $(RM) $(HOME)/.bin/oni2

.PHONY: clean
