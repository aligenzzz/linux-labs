#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/time.h>

#define MAX_THREADS 10

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
double totalElapsedTime = 0;

typedef struct
{
    int id;
    int *data;
    int size;
    int ready;
    double elapsedTime;
} ThreadData;

void *SortThread(void *arg)
{
    ThreadData *threadData = (ThreadData *)arg;

    pthread_mutex_lock(&mtx);
    printf("Thread %d is not ready.\n", threadData->id);
    pthread_mutex_unlock(&mtx);

    struct timeval start, end;
    gettimeofday(&start, NULL);

    int dataSize = threadData->size;
    while (dataSize--)
    {
        int swapped = 0;

        for (int i = 0; i < dataSize; i++)
        {
            if (threadData->data[i] > threadData->data[i + 1])
            {
                int temp = threadData->data[i];
                threadData->data[i] = threadData->data[i + 1];
                threadData->data[i + 1] = temp;
                swapped = 1;
            }
        }

        if (!swapped)
            break;
    }

    pthread_mutex_lock(&mtx);
    printf("Thread %d is ready.\n", threadData->id);
    pthread_mutex_unlock(&mtx);

    gettimeofday(&end, NULL);

    threadData->ready = 1;

    threadData->elapsedTime = (end.tv_sec - start.tv_sec) + (end.tv_usec - start.tv_usec) / 1000000.0;

    pthread_mutex_lock(&mtx);
    printf("Thread %d completed in %.6f seconds.\n", threadData->id, threadData->elapsedTime);
    totalElapsedTime = (threadData->elapsedTime > totalElapsedTime) ? threadData->elapsedTime : totalElapsedTime;
    pthread_mutex_unlock(&mtx);

    return NULL;
}

int main()
{
    int arraySize, numThreads;

    printf("Enter the size of the array: ");
    scanf("%d", &arraySize);
    printf("Enter the number of threads: ");
    scanf("%d", &numThreads);

    numThreads = (numThreads < MAX_THREADS) ? numThreads : MAX_THREADS;

    int *arrayToSort = (int *)malloc(arraySize * sizeof(int));
    pthread_t threads[MAX_THREADS];
    ThreadData threadDataArray[MAX_THREADS];

    // initializing of the array with random values
    for (int i = 0; i < arraySize; i++)
        arrayToSort[i] = rand() % 1000;

    // dividing of the array into equal parts
    int fragmentSize = arraySize / numThreads;

    // initializing of the threads array
    for (int i = 0; i < numThreads; i++)
    {
        threadDataArray[i].id = i + 1;
        threadDataArray[i].data = arrayToSort + i * fragmentSize;
        threadDataArray[i].size = (i == numThreads - 1) ? arraySize - i * fragmentSize : fragmentSize;
        threadDataArray[i].ready = 0;

        pthread_create(&threads[i], NULL, SortThread, &threadDataArray[i]);
    }

    printf("Sorting array fragments with %d threads started.\n", numThreads);

    for (int i = 0; i < numThreads; i++)
        pthread_join(threads[i], NULL);

    // waiting for all threads to end
    while (1)
    {
        int allThreadsReady = 1;
        for (int i = 0; i < numThreads; i++)
            if (!threadDataArray[i].ready)
            {
                allThreadsReady = 0;
                usleep(10000);
                break;
            }
        if (allThreadsReady)
            break;
    }

    // merging of the sorted fragments
    int *result = (int *)malloc(arraySize * sizeof(int));
    int index = 0;
    for (int i = 0; i < numThreads; i++)
    {
        for (int j = 0; j < threadDataArray[i].size; j++)
        {
            result[index++] = threadDataArray[i].data[j];
        }
    }

    printf("Sorting completed in %.6f seconds.\n", totalElapsedTime);

    free(arrayToSort);
    free(result);

    return 0;
}
