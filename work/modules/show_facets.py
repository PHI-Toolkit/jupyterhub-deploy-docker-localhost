# Display the Dive visualization for this data
from IPython.core.display import display, HTML

def show_facets(height,width,jsonstr):
    HTML_TEMPLATE = """<link rel="import" href="~/.local/share/jupyter/nbextensions/facets-dist/facets-jupyter.html"> \
<facets-dive id="elem" height={height} width={width}></facets-dive><script>var data = {jsonstr}; \
document.querySelector("#elem").data = data;</script>"""
    html = HTML_TEMPLATE.format(height=height,width=width,jsonstr=jsonstr)
    display(HTML(html))
