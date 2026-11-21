# Shared, hidden set-up for every lesson video. Include it with:  Source lessons/_shared/setup.tape
# It never appears on camera: it fetches Gradle, resolves every plugin and library, compiles the lesson, and gives the
# terminal a short prompt and the callout helper, so the video starts on a ready, warmed-up project.
Hide
Type "export PS1='$ ' GREP_COLORS='mt=01;33' && source lessons/_shared/callout.sh"
Enter
Type "./gradlew -q --console=plain help >/dev/null 2>&1 && ./gradlew -q --console=plain :lessons:${LESSON}:testClasses >/dev/null 2>&1; clear"
Enter
Wait@600s /\$ $/
Show
