script FileProcessor
    property parent : class "NSObject"
    
    property FinderSelection : "@module"
    property XFile : "@module"    
    property _ : script "ModuleLoader"'s setup(me)

    on processFinderSelection()
        try
            tell my FinderSelection's make_for_item()
                set_prompt_message(localized string "Choose a file to archive.")
                set a_selection to its get_selection()
            end tell
            main(a_selection)
        on error msg number errno
            if errno is not -128 then
                activate
                display alert msg message "Error Number : " & errno
            end if
        end try
    end processFinderSelection
    
    on main(a_list)
        --log "start main"
        set uncenter to current application's NSUserNotificationCenter's defaultUserNotificationCenter
        repeat with an_item in a_list
            set an_archive to archive(contents of an_item)
            set user_info to current application's NSDictionary's dictionaryWithObject_forKey_(an_archive's posix_path(), "path")
            set a_notification to current application's NSUserNotification's alloc()'s init()
            tell a_notification
                set its title to (localized string "Success to archive.")
                set its informativeText to an_archive's item_name()
                set its userInfo to user_info
            end tell
            uncenter's deliverNotification_(a_notification)
        end repeat
    end main
    
    on processFiles_(a_list)
        set a_list to a_list as list -- convert ObjC Object to AS Object
        try
            main(a_list)
        on error msg number errno
            if errno is not -128 then
                activate
                display alert msg message "Error Number : " & errno
            end if
        end try
        quit
    end processFiles_
    
    on copy_timestamp(x_source, x_dest)
        tell current application's NSFileManager's defaultManager()
            set attr to its attributesOfItemAtPath:(x_source's posix_path()) |error|:(missing value)
            set a_dict to {NSFileCreationDate:attr's objectForKey:"NSFileCreationDate", NSFileModificationDate:attr's objectForKey:"NSFileModificationDate"}
            its setAttributes:a_dict ofItemAtPath:(x_dest's posix_path()) |error|:(missing value)
        end tell
    end copy_timestamp

    on archive(an_item)
        set source_item to XFile's make_with(an_item)
        set a_folder to source_item's parent_folder()
        set target_item to a_folder's unique_child(source_item's item_name() & ".zip")
        set opts to ""
        if source_item's is_folder() then
            set opts to "--keepParent "
        end if
        (*
         --rsc : resource folks are stored as separate file in the same directory to data folks.
         --sequesterRsrc ; resource folks are sotred under __MACOSX
         *)
        do shell script "ditto -c -k --sequesterRsrc " & opts & quoted form of (source_item's posix_path()) & space & quoted form of (target_item's posix_path())
        copy_timestamp(source_item, target_item)
        return target_item
    end archive
end script
