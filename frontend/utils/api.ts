import axios from 'axios';

const api = axios.create({
    baseURL: process.env.NEXT_PUBLIC_BACKEND_URL,
});

const fetchGithubEvents = async () => {
    const {data} = await api.get('/github_events');

    return data;
}

const fetchNews = async () => {
    const {data} = await api.get('/news');

    return data;
};

export {fetchNews, fetchGithubEvents}