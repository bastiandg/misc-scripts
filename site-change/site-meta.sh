#!/bin/bash

IFS=$'\n'
script_dir="$(readlink -f "$(dirname "$0")")"
site_change_script="${script_dir}/site-change.sh"
site_list_path="${script_dir}/site-list.json"
mail_addresses="$(jq -r '.mails | join(" ")' "$site_list_path")"

echo "$mail_addresses"
for site_line in $(jq -r '.sites[] | [.name, .site, .contact] |  join(";")' "$site_list_path") ; do
	name="$(cut -d ';' -f 1 <<< "$site_line")"
	site="$(cut -d ';' -f 2 <<< "$site_line")"
	contact="$(cut -d ';' -f 3 <<< "$site_line")"
	"$site_change_script" "$site" "$name" "Contact $contact" "$mail_addresses" &
done
