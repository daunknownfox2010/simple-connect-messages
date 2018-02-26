# Simple Connection Messages
This addon is experimental but it allows for server owners to easily set custom connection messages. The addon covers connect, spawn and disconnect messages.

## Commands
**scm_enabled** - Enable Simple Connect Messages.<br/>
**scm_request_client_info** - Requests client information when the player initially spawns in.<br/>
**scm_server_name** - Sets the #svname format with the given string (eg. [My Server]).<br/>
**scm_connect_message** - Set the player connect message.<br/>
**scm_connect_sound** - Set the player connect sound.<br/>
**scm_loaded_message** - Set the player loaded message.<br/>
**scm_loaded_sound** - Set the player loaded sound.<br/>
**scm_disconnect_message** - Set the player disconnect message.<br/>
**scm_disconnect_sound** - Set the player disconnect sound.<br/>

## Command Formats
**scm_connect_message**, **scm_loaded_message** and **scm_disconnect_message** support "Command Formats". These allow you to enter in non-static data such as Name, IP, SteamID and Disconnection Reasons.

**#svname** - Returns what's set in **scm_server_name**. Works on all message types.<br/>
**#name** - Returns the player's name. Works on all message types.<br/>
**#ip** - Returns the player's IP Address. Only works on Connect and Loaded message types.<br/>
**#id** - Returns the player's SteamID. Works on all message types.<br/>
**#reason** - Returns the disconnection reason. Only works on Disconnect message types.<br/>
**#system** - Returns the player's OS. Only works on Loaded message types.<br/>

### Colour/Color Formats
The messages can be changed by colour formats. By default the messages are set to white but you can change it to any colour you want.

**$R,G,B** - Sets the text by the given RGB values.<br/>
**$white** - Sets the text to white.<br/>
**...**<br/>
**$black** - Sets the text to black.<br/>
