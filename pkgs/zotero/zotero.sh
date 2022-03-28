#!/bin/env bash

exec "@firefox@/bin/firefox" -app "@out@/libexec/zotero/application.ini" "${@}"
