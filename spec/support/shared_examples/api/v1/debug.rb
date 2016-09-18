## -- Just for debugging
shared_examples(:show_body) { it('...is for debug') { ap JSON.parse(body) } }
def _sb; include_examples :show_body; end
