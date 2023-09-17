'use client';

import React, { FC, useEffect, useState } from 'react';
import DashboardServer from './DashboardServer';
import { fetchNews, fetchGithubEvents } from '@/utils/api';
import { GitHubEventsData, NewsData } from "@/types";

const DashboardClient: FC = () => {
    const [newsData, setNewsData] = useState<NewsData | undefined>();
    const [eventsData, setEventsData] = useState<GitHubEventsData | undefined>();
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        (async () => {
            setLoading(true);
            const newsDataFetched = await fetchNews();
            const eventsDataFetched = await fetchGithubEvents();

            setNewsData(newsDataFetched);
            setEventsData(eventsDataFetched);
            setLoading(false);

        })();
    }, []);

    return loading ? (
        <div className="flex items-center justify-center h-screen">
            <p className="text-xl md:text-2xl lg:text-3xl font-medium text-gray-700">Loading...</p>
        </div>
    ) : (
        <DashboardServer newsData={newsData} eventsData={eventsData} />
    );
};

export default DashboardClient;
