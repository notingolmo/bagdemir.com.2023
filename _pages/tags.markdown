---
layout: page
title: By Category
permalink: /tags/
content-type: eg
---

<style>
.category-content a {
    text-decoration: none;
    color: #4183c4;
}

.category-content a:hover {
    text-decoration: underline;
    color: #4183c4;
}
</style>

<div style="display: flex; flex-wrap: wrap;">
    {% assign tag1 = "" %}
    {% assign tag2 = "" %}

    {% for tag in site.categories %}

        {% if tag1 == "" %}
            {% assign tag1 = tag %}
        {% elsif  tag1 != "" and tag2 == "" %}
            {% assign tag2 = tag %}
        {% endif %}

        {% if tag1 != "" and tag2 != "" %}

            <div style="box-sizing: border-box; width: 50%; text-align: left; padding: 5px">
                <h3 id="{{ tag1 | first }}">{{ tag1 | first | capitalize }}<hr/></h3>
                <ul>
                {% for post in tag1.last %}
                    <li><a href="{{post.url}}">{{ post.title }}</a></li>
                {% endfor %}
                </ul>
            </div>

            <div style="box-sizing: border-box; width: 50%; text-align: left; padding: 5px">
                <h3 id="{{ tag2 | first }}">{{ tag2 | first | capitalize }}<hr/></h3>
                <ul>
                {% for post in tag2.last %}
                    <li><a href="{{post.url}}">{{ post.title }}</a></li>
                {% endfor %}
                </ul>
            </div>

            {% assign tag1 = "" %}
            {% assign tag2 = "" %}

        {% endif %}

    {% endfor %}

    {% if tag1 != "" and tag2 == "" %}

        <div style="box-sizing: border-box; width: 50%; text-align: left">
            <h3 id="{{ tag1 | first }}">{{ tag1 | first | capitalize }}</h3>
            <ul>
            {% for post in tag1.last %}
                <li><a href="{{post.url}}">{{ post.title }}</a></li>
            {% endfor %}
            </ul>
        </div>

        <div style="box-sizing: border-box; width: 50%">&nbsp;</div>

        {% assign tag1 = "" %}
        {% assign tag2 = "" %}

    {% endif %}
    <br/>
    <br/>
</div>
<br />
