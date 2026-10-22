result=$(run_folo timeline "${other_args[@]}") || exit 1

output_format="${args['--output-format']}"

if [[ "$output_format" == "alfred" ]]; then
    alfred_script_filter_result=$(jq -c \
        --arg frontend_url "$KIKOERU_FRONTEND_URL" \
        --arg image_dir "$image_dir" \
        '{
            skipknowledge: true,
            cache: {
                seconds: 60
            },
            items: [
                .entries.[] | {
                    uid: ("entry-" + (.entries.id | tostring)),
                    title: .entries.title,
                }
            ]
    }' <<<"$result")

    echo "$alfred_script_filter_result"
fi
