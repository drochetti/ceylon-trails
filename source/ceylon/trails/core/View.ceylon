import ceylon.html {
    Html
}
import ceylon.html.layout {
    Layout
}

shared interface View {

    shared formal Html|Layout render();

}