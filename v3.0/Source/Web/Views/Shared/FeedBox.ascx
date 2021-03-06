﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ OutputCache Duration="300" VaryByParam="None" %>
<%@ Import Namespace="System.Xml" %>
<%
    var rssReader = new XmlTextReader("http://blog.dotnetomaniak.pl/syndication.axd");
    var rssDoc = new XmlDocument();
    XmlNode nodeRss = null;
    XmlNode nodeChannel = null;
    XmlNode nodeLastItem = null;
    rssDoc.Load(rssReader);

    for (int i = 0; i < rssDoc.ChildNodes.Count; i++)
    {
        if (rssDoc.ChildNodes[i].Name == "rss")
        {
            nodeRss = rssDoc.ChildNodes[i];
            break;
        }
    }

    for (int i = 0; i < nodeRss.ChildNodes.Count; i++)
    {
        if (nodeRss.ChildNodes[i].Name == "channel")
        {
            nodeChannel = nodeRss.ChildNodes[i];
            break;
        }
    }

    for (int i = 0; i < nodeChannel.ChildNodes.Count; i++)
    {
        if (nodeChannel.ChildNodes[i].Name == "item")
        {
            nodeLastItem = nodeChannel.ChildNodes[i];
            break;
        }
    }

    if (nodeLastItem != null)
    {
        var element = nodeLastItem;
        var pubDate = DateTime.Parse(nodeLastItem["pubDate"].InnerText);
        var text = element["description"].InnerText.StripHtml();
%>
<div class="blog">
<div class="pageHeader">
    <div class="pageTitle">
    <h2>
        Ostatnio na blogu</h2></div>
</div>    
       <p class="title">
            <a href="<%=element["link"].InnerText %>"><strong><%=element["title"].InnerText.WrapAt(30) %></strong></a>
        </p>
        <%//glupi pomysl ale na szybko - ucina string na trzecim znaku '.' %>
        <div class="blogPost"><%=text.Substring(0, text.IndexOf('.', text.IndexOf('.', text.IndexOf('.') + 1) + 1) + 1) %>
            &nbsp;<a href="<%=element["link"].InnerText %>">czytaj więcej</a>
        </div>                            
        <span class="date"><%= pubDate.ToShortDateString() %></span>
<%
    }%>
</div>
