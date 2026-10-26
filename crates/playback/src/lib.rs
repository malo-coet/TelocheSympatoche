//! Playback session: the authoritative state machine for the queue, the
//! current item, resume points and parental control. Actual decoding happens in
//! a renderer (the TV app's libmpv player), driven through the `Renderer` port.
