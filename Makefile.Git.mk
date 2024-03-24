.PHONY: setup-git-config




setup-git-config:
	cp support/gitignore_global ~/.gitignore_global
	cp support/gitmessage ~/.gitmessage
	git config --global user.name "$$(cat .env | grep USER_NAME | cut -d '=' -f2)"
	git config --global user.email "$$(cat .env | grep EMAIL_ADDRESS | cut -d '=' -f2)"
	git config --global init.defaultBranch main
	git config --global pull.rebase true
	git config --global core.autocrlf input
	git config --global core.eol lf
	git config --global core.editor code
	git config --global core.excludesfile ~/.gitignore_global
	git config --global gpg.program /opt/homebrew/bin/gpg
	git config --global commit.gpgsign false
	#git config --global user.signingkey "$$(cat .env | grep GPG_KEY_ID | cut -d '=' -f2)"
	git config --global tag.forceSignAnnotated false
	git config --global commit.template ~/.gitmessage
	git config --global alias.co checkout
	git config --global alias.br branch
	git config --global alias.ci commit
	git config --global alias.st status
	git config --global alias.unstage 'reset HEAD --'
	git config --global alias.last 'log -1 HEAD'
	git config --global alias.visual '!gitk'
	git config --global credential.helper cache