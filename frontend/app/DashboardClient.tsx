'use client';

import React, {FC, useEffect, useState} from 'react';
import DashboardServer from './DashboardServer';
import {fetchNews, fetchGithubEvents} from '@/utils/api';
import {GitHubEvent, GitHubEventsData, NewsData} from "@/types";
import {createConsumer} from '@rails/actioncable';

const DashboardClient: FC = () => {
    const [newsData, setNewsData] = useState<NewsData | undefined>();
    const [eventsData, setEventsData] = useState<GitHubEventsData | undefined>();
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const consumer = createConsumer(`ws://${process.env.NEXT_PUBLIC_BACKEND_HOST}/cable`);

        consumer.subscriptions.create("GithubEventsChannel", {
            received(event: GitHubEvent) {
                setEventsData(prevEventsData => {
                    if (prevEventsData) {
                        return {
                            ...prevEventsData,
                            events: [...prevEventsData.events, event]
                        };
                    }

                    return prevEventsData;
                });
            }
        });

        (async () => {
            setLoading(true);
            const eventsDataFetched = await fetchGithubEvents();

            setEventsData(eventsDataFetched);
            setLoading(false);

        })();
    }, []);

    const handleFetchNews = async () => {
        const newsDataFetched = await fetchNews();
        setNewsData(newsDataFetched);
    };

    return loading ? (
        <div className="flex items-center justify-center h-screen bg-gray-100">
            <div className="animate-spin rounded-full h-32 w-32 border-t-4 border-b-4 border-blue-900"></div>
        </div>
    ) : (
        <div className="bg-gray-100 min-h-screen py-6 flex flex-col justify-center sm:py-12">
            <div className="relative py-3 sm:max-w-xl mx-auto text-center">
                <span className="text-2xl font-light">Your Awesome Dashboard</span>
            </div>
            <div className="mt-12">
                <DashboardServer newsData={newsData} eventsData={eventsData} fetchNews={handleFetchNews}/>
            </div>
        </div>
    );
};

export default DashboardClient;
