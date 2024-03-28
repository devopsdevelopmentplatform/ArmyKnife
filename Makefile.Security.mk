# Main Makefile for TakeOut Hardening Tasks

define BANNER
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
	@echo "TTTTTTTTTTTTTTTTTTTTTTT                kkkkkkkk                                 OOOOOOOOO                              tttt          "
	@echo "T:::::::::::::::::::::T                k::::::k                               OO:::::::::OO                         ttt:::t          "
	@echo "T:::::::::::::::::::::T                k::::::k                             OO:::::::::::::OO                       t:::::t          "
	@echo "T:::::TT:::::::TT:::::T                k::::::k                            O:::::::OOO:::::::O                      t:::::t          "
	@echo "TTTTTT  T:::::T  TTTTTTaaaaaaaaaaaaa    k:::::k    kkkkkkk eeeeeeeeeeee    O::::::O   O::::::Ouuuuuu    uuuuuuttttttt:::::ttttttt    "
	@echo "        T:::::T        a::::::::::::a   k:::::k   k:::::kee::::::::::::ee  O:::::O     O:::::Ou::::u    u::::ut:::::::::::::::::t    "
	@echo "        T:::::T        aaaaaaaaa:::::a  k:::::k  k:::::ke::::::eeeee:::::eeO:::::O     O:::::Ou::::u    u::::ut:::::::::::::::::t    "
	@echo "        T:::::T                 a::::a  k:::::k k:::::ke::::::e     e:::::eO:::::O     O:::::Ou::::u    u::::utttttt:::::::tttttt    "
	@echo "        T:::::T          aaaaaaa:::::a  k::::::k:::::k e:::::::eeeee::::::eO:::::O     O:::::Ou::::u    u::::u      t:::::t          "
	@echo "        T:::::T        aa::::::::::::a  k:::::::::::k  e:::::::::::::::::e O:::::O     O:::::Ou::::u    u::::u      t:::::t          "
	@echo "        T:::::T       a::::aaaa::::::a  k:::::::::::k  e::::::eeeeeeeeeee  O:::::O     O:::::Ou::::u    u::::u      t:::::t          "
	@echo "        T:::::T      a::::a    a:::::a  k::::::k:::::k e:::::::e           O::::::O   O::::::Ou:::::uuuu:::::u      t:::::t    tttttt"
	@echo "      TT:::::::TT    a::::a    a:::::a k::::::k k:::::ke::::::::e          O:::::::OOO:::::::Ou:::::::::::::::uu    t::::::tttt:::::t"
	@echo "      T:::::::::T    a:::::aaaa::::::a k::::::k  k:::::ke::::::::eeeeeeee   OO:::::::::::::OO  u:::::::::::::::u    tt::::::::::::::t"
	@echo "      T:::::::::T     a::::::::::aa:::ak::::::k   k:::::kee:::::::::::::e     OO:::::::::OO     uu::::::::uu:::u      tt:::::::::::tt"
	@echo "      TTTTTTTTTTT      aaaaaaaaaa  aaaakkkkkkkk    kkkkkkk eeeeeeeeeeeeee       OOOOOOOOO         uuuuuuuu  uuuu        ttttttttttt  "
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
	@echo "                                                                                                                                 "
endef

SUB_MAKEFILES := Makefile.SecureRootAccess Makefile.AutomateUpdates Makefile.DisableAutoUpdates Makefile.RestrictServiceAccounts Makefile.ConfigureUserGroups Makefile.EnforceSudoReauthentication Makefile.LimitShellAccess

.PHONY: all lockroot unattended-upgrades disable-autoupdate disable-accounts essential-groups disable-sudo-timeout prevent-root-shell

all: banner lockroot disable-autoupdate disable-accounts essential-groups disable-sudo-timeout prevent-root-shell

menu: banner
	@echo "Select a task to run:"
	@echo "1) Lock Root Account"
	@echo "2) Automate System Updates"
	@echo "3) Disable Automatic System Updates"
	@echo "4) Disable Non-Essential Service Accounts"
	@echo "5) Configure Essential User Groups"
	@echo "6) Enforce Sudo Reauthentication"
	@echo "7) Limit Shell Access for Users"
	@echo "Enter the number (e.g., 1) and press [ENTER]:"
	@read choice; \
	case $$choice in \
		1) $(MAKE) lockroot;; \
		2) $(MAKE) unattended-upgrades;; \
		3) $(MAKE) disable-autoupdate;; \
		4) $(MAKE) disable-accounts;; \
		5) $(MAKE) essential-groups;; \
		6) $(MAKE) disable-sudo-timeout;; \
		7) $(MAKE) prevent-root-shell;; \
		*) echo "Invalid option selected!";; \
	esac

banner:
	$(BANNER)


check-sub-makefiles:
	@$(foreach mf, $(SUB_MAKEFILES), \
		if [ ! -f $(mf) ]; then \
			echo "Error: Missing $(mf) file, aborting."; \
			exit 1; \
		else \
			echo "Found $(mf)"; \
		fi; )


# Include sub-Makefiles
include security/Makefile.SecureRootAccess
include security/Makefile.AutomateUpdates
include security/Makefile.DisableAutoUpdates
include security/Makefile.RestrictServiceAccounts
include security/Makefile.ConfigureUserGroups
include security/Makefile.EnforceSudoReauthentication
include security/Makefile.LimitShellAccess

