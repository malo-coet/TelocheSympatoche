# Extension developer guide

Extensions add features to the media center without changing its code: content sources, metadata
providers, home screen widgets and services. They run in a WebAssembly sandbox and only get the
capabilities their manifest declares and the user accepts.

This guide is written alongside the extension system (iteration 3). It will cover the API, the package
and manifest format, permissions, the lifecycle, publishing, and a complete tutorial from an empty
folder to a working extension.
