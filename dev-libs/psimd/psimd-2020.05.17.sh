#!/bin/sh
source "../../common/init.sh"

CommitId=072586a71b55b7f8c584153d223e95687148a900

get https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz ${P}.tar.gz
acheck

docmake

finalize
