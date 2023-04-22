---
date: 2022-05-18 10:37:00+00:00
draft: false
title: On Data Governance
type: post
#featured_image: '/images/data_governance_img.jpg'
url: /2022/05/on-data-governance/
categories:
- Data Analysis
language:
- English
tags:
- essay
---


![geometric shape digital wallpaper](https://images.unsplash.com/photo-1523961131990-5ea7c61b2107?ixid=MnwzMjkwOTB8MHwxfGFsbHx8fHx8fHx8fDE2NTI2OTczODQ&ixlib=rb-1.2.1&fm=jpg&q=85&fit=crop&w=1024&h=768)
Photo by [fabio](https://unsplash.com/@fabioha) on [Unsplash](https://unsplash.com/?utm_source=carlos-yanez-santibanez&utm_medium=referral)





With the massification of the Internet and the advent of digital technologies, the ability to process large volumes of data has become a key aspect of how organisations (private and government) conduct their businesses. By becoming data-driven, private companies, government and not-for-profit institutions aim to gain insight and create value for their stakeholders. However, this task is not always easy: according to Accenture, many organisations find it difficult to derive value from data, which can be expressed as a gap between the actual and potential value of their data assets (Accenture 2019). In the same line, McKinsey reports that lack of data quality and availability results in organisations spending a considerable amount of time working on non-value added data tasks (McKinsey 2019). The conclusion in both cases is that the absence of an effective data strategy/data framework prevents maximising the value from data, even if there is organisational awareness of the potential.







# What is data governance?







A key element of a data strategy is **data governance**. Like many similar industry and process terms, there are many variations when defining the term. Some of the definitions found in the references are:





  * “[…] culture, functions, processes, and authorities to shape the execution, control and management of the enterprise data.” (Accenture 2019)  * “Data governance is everything you do to ensure data is secure, private, accurate, available, and usable.[…]” (Google 2022)  * “Data governance is the process of managing the availability, usability, integrity and security of the data in enterprise systems, based on internal data standards and policies that also control data usage.”(TechTarget 2022).  * “Data governance is a required business capability if you want to get value from your data” (Ladley 2019, ch.3, page 17).





All sources agree that despite high awareness of the value of data across organisations, data governance is usually not given the importance it deserves. Lack of data literacy prevents a clear understanding of the strategic importance of this function, being relegated as an “IT capability”. However, data governance is a strategic capability that requires broad appeal and sponsorship across organisations in order to succeed. (Ladley 2019) also states that the demand for a tangible return on investment (ROI) prevents from understanding the value it brings. Good data governance adds value in the same sense that adequate accounting or supply chain standards add value to an organisation - bad/poor data governance will result in missed opportunities at best, and costly mistakes at worst (TechTarget 2019), (Wikipedia 2022).







Another common key point is that effective data governance (like any governance) entails a cultural change. While tools and processes may facilitate quality assurance, privacy, compliance and other aspects, key success factors are strong sponsorship from the leadership and genuine adoption across the organisation. Taking this into account, creating a data governance capability requires a strong practice of change management across the organisation.







As expected, all sources consulted provide slightly different definitions of the building blocks of data governance. Nevertheless, the common ground on data governance scope includes:





  * Defining data standards, including data dictionaries and metadata.  * Ensuring that data is accessible.  * Ensuring data privacy and security.  * Ensuring data is trustworthy through quality assurance.  * Ensuring data consistency across the organisation (master data management).  * Provide data stewardship across the entire organisation.  * Champion data literacy.





# Adoption Challenges







Although the topic has become popular alongside the emergence of advanced analytics and ML/AI, data governance is a capability that is necessary even when data is used in “simpler ways”. Examples of this are Nike shares being downgraded due to poor inventory management (CNBC 2017) or NASA’s Mars Climate Orbiter crashing on landing due to a units mix-up during the design phase (i.e. poor data dictionary) (Wired 2010).







Any governance capability tends to be invisible when it operates successfully, with issues becoming apparent when it doesn’t exist or it is incomplete. This is consistent with all the consulted sources, which emphasise the effects of lacking data governance. Furthermore (Ladley 2019) stresses the point that a successful data governance capability implies a cultural change and an improvement in data literacy across an organisation, with no additional ongoing resources/staffing if done right.







Lacking appropriate data standards, difficulty accessing the right data and having low trust in data accuracy can be major challenges. Unfortunately, with the explosion of data and the systems that create, store and consume data, large organisations struggle with creating consistent data rules across them. This is aggravated by scenarios where organisations are siloed and/or rely heavily on outsourcing, effectively creating additional barriers that prevent data to flow consistently between different parties.







As a result of this, getting any outcomes can be really challenging. As indicated by all the sources consulted, lack of adequate data governance expresses itself in multiple ways - in my experience, I have encountered the following:





  * **Lack of data standards** is perhaps the most recurrent issue I have faced working with data. This includes the way the data is distributed (e.g. having to deal with a database dump file, an Excel spreadsheet and a Word table), the lack of data dictionaries (e.g. date formats, lack of a single set of geographical names), any lack of metadata (e.g. not knowing the source or if a data set is current).  * **Poor data accessibility** due to a sprawling application ecosystem. For security and privacy reasons access to systems can be restricted, and there is no defined method to extract data from them. This results in valuable information being locked out, or extremely difficult to extract at volumes.  * **Deficient data collection**. Although it can be sometimes difficult to forecast what needs to be recorded, it is not infrequent to see occasions where little thought has been given to what and how is recorded. This will result in extra work to process the data to obtain the insights or metrics that motivated the data collection in the first place.





(Ladley 2019) correctly points out this is an organisational culture and processes challenges. Tools can facilitate the implementation of data governance, but its success depends on the organisation changing its cultural practices when working with data. This is consistent with my experience leading a team that suffered from inconsistent reporting, where it took almost a year to turn around the way they conducted their data input activities. In this case, the problem was not the absence of standards and guidelines on both data input and reporting but a lack of enthusiasm to comply and change the way they worked. The turning point was when the entire team understood and realised the value of adherence: individuals providing data were able to dedicate less time to data entry and providing clarifications to managers, people creating reports were able to elevate the quality of their work and focus on high-value analysis, managers were provided with more trustworthy, solid points to bring forward to stakeholders. In general, the whole team was able to better identify areas of improvement and highlight their strengths.







# Closing Thoughts







Data accessibility, reliability and quality can be a major challenge. Although there is awareness of the value of data, organisations have lacked an understanding of the difficulties and effort involved in obtaining insights from a messy data landscape. Sometimes awareness that organisations are gathering vast amounts of data helps reinforce a perception that’s enough to obtain value. Sometimes organisations rely on new tools and technologies to bring some order but without adequate data literacy, these investments don’t meet the expectations.







As a data analyst, the most patent benefit of adequate data governance comes from having data from which reliable, trustworthy outcomes can be obtained. Any model or analysis will depend on having “good data” as the source material. This extends beyond the purely practical: it is also an ethical imperative (e.g. is the data allowing to achieve fair results?) and has regulation compliance implications (e.g. is personal data respected according to GDPR?). Obviously, this will also affect the amount of time spent in data cleaning, and free time for the creative, “high-value” parts of data analysis.







Finally, data analysts have the opportunity to play in ensuring successful governance practices. Being amongst the most data literate individual in any organisation, data analysts have a key advocacy role to play, helping to set the standards, championing processes and showcasing the ways that governance add value (through their work). This should be seen as a key part of the job, since “good data” (in a broad sense) will only facilitate and enhance a data analyst’s work and outcomes.







# References







Accenture 2019, ‘Closing the Data-Value Gap’, retrieved March 15, 2022, from <[https://www.accenture.com/_acnmedia/pdf-108/accenture-closing-data-value-gap-fixed.pdf](https://www.accenture.com/_acnmedia/pdf-108/accenture-closing-data-value-gap-fixed.pdf)>. CNBC 2017, ‘Goldman downgrades Nike due to “excess inventory” at retailers’, _CNBC_, retrieved March 16, 2022, from <[https://www.cnbc.com/2017/10/19/goldman-downgrades-nike-due-to-excess-inventory-at-retailers-shares-fall.html](https://www.cnbc.com/2017/10/19/goldman-downgrades-nike-due-to-excess-inventory-at-retailers-shares-fall.html)>. Google 2022, ‘What is Data Governance?’, _Google Cloud_, retrieved March 7, 2022, from <[https://cloud.google.com/learn/what-is-data-governance](https://cloud.google.com/learn/what-is-data-governance)>. Ladley, J 2019, _Data governance: How to design, deploy and sustain an effective data governance program_ 2nd edn, Academic Press, retrieved from <[https://go.exlibris.link/lv3m1gf6](https://go.exlibris.link/lv3m1gf6)>. McKinsey 2019, ‘Designing data governance that delivers value’,. TechTarget 2019, ‘What is Data Quality and Why is it Important?’, _SearchDataManagement_, retrieved March 16, 2022, from <[https://www.techtarget.com/searchdatamanagement/definition/data-quality](https://www.techtarget.com/searchdatamanagement/definition/data-quality)>. TechTarget 2022, ‘What Is Data Governance and Why Does It Matter?’, _SearchDataManagement_, retrieved March 20, 2022, from <[https://www.techtarget.com/searchdatamanagement/definition/data-governance](https://www.techtarget.com/searchdatamanagement/definition/data-governance)>. Wikipedia 2022, ‘GDPR fines and notices’, _Wikipedia_, retrieved March 20, 2022, from <[https://en.wikipedia.org/w/index.php?title=GDPR_fines_and_notices&oldid=1064935377](https://en.wikipedia.org/w/index.php?title=GDPR_fines_and_notices&oldid=1064935377)>. Wired 2010, ‘Nov. 10, 1999: Metric Math Mistake Muffed Mars Meteorology Mission’, _Wired_, retrieved March 16, 2022, from <[https://www.wired.com/2010/11/1110mars-climate-observer-report/](https://www.wired.com/2010/11/1110mars-climate-observer-report/)>.







