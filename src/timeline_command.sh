output_format="${args['--output-format']}"

if [[ "$output_format" == "alfred" ]]; then
    result=$(run_folo timeline "${other_args[@]}") || {
        alfred_error=$(jq -nc \
            --arg message "$result" \
            '{
                items: [
                    {
                        title: $message,
                        valid: false
                    }
                ]
            }')
        printf "%s\n" "$alfred_error"
        exit 1
    }

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

    printf "%s\n" "$alfred_script_filter_result"
fi
