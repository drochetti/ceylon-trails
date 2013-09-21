import ceylon.html {
    Html
}
import ceylon.html.layout {
    Layout
}

shared interface View<Kind> {

    shared formal Kind render();

}

shared interface HtmlView satisfies View<Html|Layout> {}