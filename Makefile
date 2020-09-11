NAME=onivim-dl
BIN_DIR=$(HOME)/.bin
BIN_NAME=oni2
INSTALL_DIR=$(HOME)/.opt/Onivim2
CACHE_DIR=$(HOME)/.cache/$(NAME)
CONFIG_DIR=$(HOME)/.config/$(NAME)

EXEC=npm start --

clean:
	$(RM) -r $(CACHE_DIR)

download:
	$(EXEC) download

install: download
	@test -d $(BIN_DIR) || mkdir -pv $(BIN_DIR)
	@test -d $(CACHE_DIR) || mkdir -pv $(CACHE_DIR)
	@test -d $(CONFIG_DIR) || mkdir -pv $(CONFIG_DIR)
	@test -d $(INSTALL_DIR) || mkdir -pv $(INSTALL_DIR)
	@echo "Installing to $(INSTALL_DIR)"
	@tar xzf $(CACHE_DIR)/latest -C $(INSTALL_DIR) --strip-components=1 Onivim2.AppDir
	@echo "Symlinking executable to $(BIN_DIR)/$(BIN_NAME)"
	@test -e $(BIN_DIR)/$(BIN_NAME) || ln -s $(INSTALL_DIR)/AppRun $(BIN_DIR)/$(BIN_DIR)

uninstall:
	@echo $(RM) -r $(INSTALL_DIR)
	@echo $(RM) -r $(CACHE_DIR)
	@echo $(RM) -r $(CONFIG)
	@echo $(RM) $(BIN_DIR)/oni2

.PHONY: clean download install uninstall
