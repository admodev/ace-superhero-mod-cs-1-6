{<includes/global.inc}
{<includes/head.inc}

<div align=center>
{v.authed?
{P.content?
{>{W.moddir}/{P.filename}:{P.content}}
File saved !
{h.location:/config.w}
:
<b>.\: Editing <i>{P.filename}</i> \:.</b>
<br><br>
<form action=fileedit.w method=post name=fedit>
<input type=hidden name=filename value="{P.filename}">
<textarea name="content" rows=25 cols=80>{<<{W.moddir}/{P.filename}}</textarea>
<br><br><input type=submit value="Save">
</form>
</div>
}
:
{h.location:/auth.w?redir=config.w}
}
{<includes/tail.inc}