(* Get the current song from iTunes or Spotify *)
if application "iTunes" is not running then
      return " Music 🔈 "
end if

if application "iTunes" is running then
  tell application "iTunes"
    if exists current track then
      set theName to the name of the current track
      set theArtist to the artist of the current track
      try
        return "♫  " & theName & " - " & theArtist
      on error err
      end try
      else 
        return " Music 🔈 "
    end if
  end tell
end if
if application "Spotify" is running and application "iTunes" is not running then
  tell application "Spotify"
    if exists current track then
      set theName to the name of the current track
      set theArtist to the artist of the current track
      try
        return "♫  " & theName & " - " & theArtist
      on error err
      end try
      else 
        return " Music 🔈 "
    end if
  end tell
end if

